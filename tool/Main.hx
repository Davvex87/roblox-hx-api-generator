package;

import Types;
import sys.io.Process;
import hx.files.Path;
import haxe.ds.Either;
import hx.files.File;
import hx.files.Dir;
import sys.FileSystem;
import haxe.Json;
import sys.Http;
import preprocessors.*;

using hx.strings.Strings;

final ROBLOX_API_ENDPOINT:String = "https://setup.rbxcdn.com/";

class Main
{
	public static var ARGUMENTS = Sys.args();

	static var noPrint:Bool = false;
	static var outputPath:Path = null;

	static var preprocessors:Array<IPreprocessor> = [new MissingOptionals()];

	static function main()
	{
		trace(ARGUMENTS);
		if (ARGUMENTS.length > 0)
		{
			var path:String = Sys.getCwd();
			var types:Bool = false;

			for (arg in ARGUMENTS)
			{
				switch (arg)
				{
					case "--no-print", "-o":
						noPrint = true;
					case "--types", "-t":
						types = true;
					default:
						path = arg;
				}
			}
			return runExtraction(Path.of(path), types);
		}

		println("Choose your desired output destination folder:");
		println("  (1) roblox-hx proxy directory");
		println("  (2) cwd location");
		println("  (3) custom location");
		println("  ( ) cancel");
		print("\n  > ");

		switch (Sys.getChar(true))
		{
			case '1'.code:
				outputPath = getLibraryDir("roblox-hx").join("src");
			case '2'.code:
				outputPath = Dir.getCWD().path;
			case '3'.code:
				var inp = Sys.stdin();
				print("\nPath: ");
				var path = inp.readLine();
				outputPath = Path.of(path.trim());
			default:
				println("\n\nOPERATION CANCELED!");
				Sys.exit(0);
		}

		var copyTypes = true;
		println("\nCopy types definitions to output? (Y/n): ");
		switch (Sys.getChar(true))
		{
			case 'N'.code, 'n'.code, '0'.code, 'f'.code:
				copyTypes = false;
		}

		runExtraction(outputPath, copyTypes);
		return;
	}

	public static function runExtraction(outputPath:Path, copyTypes:Bool)
	{
		if (outputPath == null || !outputPath.exists())
		{
			Sys.stderr().writeString("Unable to locate selected path!");
			Sys.exit(1);
			return;
		}

		if (noPrint)
		{
			print = function(v:Dynamic) {};
			println = function(v:Dynamic) {};
		}

		print("\n\nFetching latest API dump... ");

		outputPath.join("rblx").toDir().create();

		var data:{Classes:Array<ClassObj>, Enums:Array<EnumObj>, Version:Int} = Json.parse(fetchDump(null));

		// Add custom enums, classes and object members that are not present in the API dump
		var enums:Array<EnumObj> = cast Reflect.field(data, "Enums");
		enums.push({
			Items: [
				{
					Name: "None",
					Value: 0
				},
				{
					Name: "Uri",
					Value: 1
				},
				{
					Name: "Object",
					Value: 2
				}
			],
			Name: "ContentSourceType"
		});

		var classes = data.Classes;
		var enums = data.Enums;

		for (preprocessor in preprocessors)
		{
			println('\nRunning preprocessor: ${Type.getClassName(Type.getClass(preprocessor))}...');
			preprocessor.build(classes, enums);
		}

		parseEnums(enums);
		println("");
		parseClasses(classes);
		println("");
		if (copyTypes)
			copyTypesToOutput(outputPath);
		println("Done!");

		return;
	}

	static function copyTypesToOutput(outputPath:Path)
	{
		final dir = Dir.getCWD().path.join("types").toDir();
		if (!dir.path.exists())
		{
			Sys.stderr().writeString("Unable to locate types path, skip!");
			return;
		}
		var lastLen:UInt = 0;
		var files = dir.listFiles();
		for (i in 0...files.length)
		{
			print('\rCopying types... (${i + 1}/${files.length}) ${formatBytes(lastLen)}    ');
			files[i].copyTo(outputPath.join("rblx").join(files[i].path.filename), [OVERWRITE]);
			lastLen += getUtf8Length(files[i].readAsString());
		}
	}

	public static function parseClasses(classes:Array<ClassObj>)
	{
		outputPath.joinAll(["rblx", "services"]).toDir().create();
		outputPath.joinAll(["rblx", "instances"]).toDir().create();

		var lastLen:UInt = 0;
		for (i in 0...classes.length)
		{
			var cls = classes[i];
			if (cls.Name == "Studio")
				continue;

			print('\rParsing classes... (${i + 1}/${classes.length}) ${formatBytes(lastLen)}    ');

			var pkg:String = "rblx";

			var objTags = Reflect.hasField(cls, "Tags") ? cls.Tags : [];

			if (objTags.contains("Service"))
				pkg = '$pkg.services';
			else
				pkg = '$pkg.instances';

			var filePath:Path = outputPath;
			for (p in pkg.split("."))
				filePath = filePath.join(p);

			filePath = filePath.join('${cls.Name}.hx');
			Dir.of(filePath.parent).create();

			var stream = new StringBuf();
			stream.add('package ${pkg};\n\n');

			stream.add('// ADD IMPORTS HERE\n\n');

			if (pkg.endsWithIgnoreCase("services"))
			{
				stream.add('@:native("${cls.Name}")\n');
				stream.add('@:customImport("game:GetService(\'${cls.Name}\')")\n');
			}

			if (objTags.contains("Deprecated"))
				stream.add("@:deprecated\n");

			stream.add('@:rblx${objTags.contains("Service") ? "Service" : "Object"}\n');
			stream.add('extern class ${cls.Name}');
			if (Reflect.hasField(cls, "Superclass") && cls.Superclass != "<<<ROOT>>>")
				stream.add(' extends ${cls.Superclass}');

			stream.add('\n{\n');

			if (pkg.endsWithIgnoreCase("instances") && !objTags.contains("NotCreatable"))
			{
				stream.add('\t@:nativeFunctionCode(\'Instance.new("${cls.Name}")\')\n');
				stream.add('\tpublic function new();\n\n');
			}

			var clsFields = cls.Members.copy();
			var blacklist = [];

			for (field in clsFields)
			{
				if (Reflect.hasField(field, "Tags") && field.Tags.contains("Deprecated"))
				{
					for (f in cls.Members)
					{
						if (field.Name.toLowerCamel() == f.Name.toLowerCamel() && field != f)
						{
							blacklist.push(field);
							break;
						}
					}
				}
			}

			for (item in blacklist)
				clsFields.remove(item);

			for (mem in clsFields)
			{
				if (fieldExistsInSuper(classes, cls, mem.Name))
					continue;

				var readonly = false;

				if (Reflect.hasField(mem, "Tags"))
				{
					if (mem.Tags.contains("Hidden"))
						stream.add('\t@:noCompletion\n');
					if (mem.Tags.contains("Deprecated"))
						stream.add('\t@:deprecated\n');

					if (mem.Tags.contains("ReadOnly"))
						readonly = true;
				}

				switch (mem.MemberType)
				{
					case Property:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tvar ');
						stream.add('${parseName(mem.Name)}${readonly ? '(default, never)' : ''}:${parseType(mem.ValueType)};\n\n');

					case Function:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tfunction ');
						stream.add('${parseName(mem.Name)}(');
						var funcParams:Array<String> = [];
						for (param in mem.Parameters)
							funcParams.push('${parseFieldArg(param)}');
						stream.add('${funcParams.join(", ")}):${parseType(mem.ReturnType)};\n\n');

					case Event:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tvar ');
						stream.add('${parseName(mem.Name)}:RBXScriptSignal<(');
						var funcParams:Array<String> = [];
						for (param in mem.Parameters)
							funcParams.push('${parseFieldArg(param)}');
						stream.add('${funcParams.join(", ")})->Void>;\n\n');

					case Callback:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tvar ');
						stream.add('${parseName(mem.Name)}:(');
						var funcParams:Array<String> = [];
						for (param in mem.Parameters)
							funcParams.push('${parseFieldArg(param)}');
						stream.add('${funcParams.join(", ")})->${parseType(mem.ReturnType)};\n\n');

					default:
						println('\x1b[33mUnknown member type "${mem.MemberType}", skipping\x1b[0m');
				}
			}

			stream.add('}');

			var output = stream.toString();

			var imports:Array<String> = ["rblx.*", "rblx.instances.*", "rblx.services.*", "rblx.enums.*"];
			var importsStr = new StringBuf();

			if (output.contains("StringMap"))
				imports.push("haxe.ds.StringMap");

			if (imports.length > 0)
			{
				for (imp in imports)
					importsStr.add('import ${imp};\n');
				importsStr.add("\n");
			}

			output = output.replaceAll("// ADD IMPORTS HERE\n\n", importsStr.toString());

			File.of(filePath).writeString(output);
			lastLen += getUtf8Length(output);
		}

		print('\rParsing classes... (${classes.length}/${classes.length}) ${formatBytes(lastLen)}    ');
	}

	static function fieldExistsInSuper(classes:Array<ClassObj>, cls:ClassObj, field:String):Bool
	{
		var superClass:Null<ClassObj> = null;
		superClass = classes.filter(c -> c.Name == cls.Superclass).shift();
		if (superClass == null)
			return false;

		for (f in superClass.Members)
		{
			if (f.Name.toLowerCamel() == field.toLowerCamel())
				return true;
		}

		return fieldExistsInSuper(classes, superClass, field);
	}

	static function parseName(str:String, noFormat:Bool = false):String
	{
		var out = str.toLowerCamel();
		if (out == "function" || out == "default" || out == "var" || out == "extern" || out == "class" || out == "enum" || out == "switch"
			|| out == "import" || out == "using" || out == "final" || out == "public" || out == "private" || out == "static" || out == "case"
			|| out == "for" || out == "return" || out == "if" || out == "else" || out == "in" || out == "to" || out == "from" || out == "package"
			|| out == "typedef" || out == "implements" || out == "interface" || out == "operator" || out == "override" || out == "abstract"
			|| out == "break" || out == "continue" || out == "true" || out == "false" || out == "null" || out == "new" || out == "is")
			return '${noFormat ? str : out}_';
		return noFormat ? str : out;
	}

	static function parseFieldArg(field:ParamArg):String
	{
		var info = {
			n: parseName(field.Name),
			t: parseType(field.Type),
			d: parseDefault(field)
		}

		var optional = field.Type.Name.endsWith("?") || (info.d != null && info.d.d == null);
		return '${optional ? "?" : ""}${info.n}:${info.t}${optional ? "" : info.d != null ? " = " + info.d.d : ""}';
	}

	static function parseType(typeObj:ParamTypeObj)
	{
		var n = typeObj.Name;
		if (n.endsWith("?"))
			n = n.substr(0, n.length - 1);

		var type = switch (typeObj.Category)
		{
			case Primitive:
				switch (n)
				{
					case 'bool':
						"Bool";
					case 'string':
						"String";
					case 'int' | 'int64':
						"Int";
					case 'float' | 'double':
						"Float";
					case 'null':
						"Void";
					default:
						"Dynamic";
				}

			case DataType:
				switch (n)
				{
					case "BinaryString":
						"String";
					case "QDir":
						"Dynamic";
					case "QFont":
						"Dynamic";
					case "CoordinateFrame":
						"CFrame";
					case "OpenCloudModel":
						"Dynamic";
					case "SharedTable":
						"Dynamic";
					case "Objects":
						"Array<Instance>";
					case "RBXScriptSignal":
						"RBXScriptSignal<()->Void>";
					case "Function":
						"haxe.Constraints.Function";
					case "OptionalCoordinateFrame": // What??
						"CFrame";
					case "ProtectedString":
						"String";
					default:
						n;
				}

			case Class:
				n;
			case Enum:
				'EnumItem<$n>';
			case Group:
				switch (n)
				{
					case "Variant":
						"Dynamic";
					case "Dictionary":
						"StringMap<Dynamic>";
					case "Array":
						"Array<Dynamic>";
					case "Tuple":
						"Dynamic";
					case "Map":
						"Map<Dynamic, Dynamic>";
					default:
						"Dynamic";
				}
			default:
				"Dynamic";
		}

		if (typeObj.Name.endsWith("?"))
			return 'Null<${type}>';

		return type;
	}

	static function parseDefault(field:ParamArg):Null<{d:Null<String>}>
	{
		var typeObj:ParamTypeObj = field.Type;
		var pdefault:String = field.Default;

		if (pdefault == null)
			return null;

		if (pdefault == "")
			return {d: '""'};
		if (pdefault == "nil")
			return {d: null};

		var optional:Bool = typeObj.Name.endsWith("?");

		var n = typeObj.Name;
		if (n.endsWith("?"))
			n = n.substr(0, n.length - 1);

		switch (typeObj.Category)
		{
			case Primitive:
				switch (n)
				{
					case 'bool':
						return {d: '$pdefault'};
					case 'string':
						return {d: '"$pdefault"'};
					case 'int' | 'int64':
						return {d: '$pdefault'};
					case 'float' | 'double':
						return {d: '$pdefault'};
					case 'null':
						return null;
					default:
				}

			case DataType:
				switch (n)
				{
					case "BinaryString":
						return {d: '"$pdefault"'};
					case "QDir":
						return {d: null};
					case "QFont":
						return {d: null};
					case "CoordinateFrame":
						return {d: null};
					case "OpenCloudModel":
						return {d: null};
					case "SharedTable":
						return {d: null};
					case "Objects":
						return {d: null};
					case "RBXScriptSignal":
						return {d: null};
					case "Function":
						return {d: null};
					case "OptionalCoordinateFrame": // What??
						return {d: null};
					case "ProtectedString":
						return {d: null};
					default:
				}

			case Class:
				return {d: null};
			case Enum:
				return {d: null};
			case Group:
				switch (n)
				{
					case "Variant":
						return {d: null};
					case "Dictionary":
						return {d: null};
					case "Array":
						return {d: null};
					case "Tuple":
						return {d: null};
					case "Map":
						return {d: null};
					default:
						return {d: null};
				}
			default:
		}
		return {d: null};
	}

	public static function parseEnums(enums:Array<EnumObj>)
	{
		outputPath.joinAll(["rblx", "enums"]).toDir().create();

		var lastLen:UInt = 0;
		for (i in 0...enums.length)
		{
			print('\rParsing enums... (${i + 1}/${enums.length}) ${formatBytes(lastLen)}    ');

			var en = enums[i];
			var stream = new StringBuf();

			var name = en.Name;

			stream.add('package rblx.enums;\n\n');
			stream.add('// ADD IMPORTS HERE\n\n');
			stream.add('@:native("Enum.$name")\n');
			stream.add('@:rblxEnum\n');
			// stream.add('extern class ${en.Name}\n{\n');
			stream.add('extern enum abstract $name(EnumItem<$name>)\n{\n');

			for (item in en.Items)
			{
				stream.add('\tvar ${parseName(item.Name, true)}:EnumItem<$name>;\n');
			}

			stream.add('}');

			var output = stream.toString();

			var imports:Array<String> = ["rblx.*"];
			var importsStr = new StringBuf();

			if (imports.length > 0)
			{
				for (imp in imports)
					importsStr.add('import ${imp};\n');
				importsStr.add("\n");
			}

			output = output.replaceAll("// ADD IMPORTS HERE\n\n", importsStr.toString());

			File.of(outputPath.joinAll(['rblx', 'enums', '${en.Name}.hx'])).writeString(output);
			lastLen += getUtf8Length(output);
		}

		print('\rParsing enums... (${enums.length}/${enums.length}) ${formatBytes(lastLen)}    ');
	}

	public static function fetchDump(?version:String):String
	{
		var target = File.of(outputPath.join('api-dump.json'));
		// if (target.path.exists())
		//	return target.readAsString();

		return downloadDump(version);
	}

	public static function downloadDump(?version:String):String
	{
		if (version == null)
			version = Http.requestUrl('${ROBLOX_API_ENDPOINT}versionQTStudio');

		println('($version)');

		var jsonDump = Http.requestUrl('${ROBLOX_API_ENDPOINT}${version}-API-Dump.json');

		var stream = new StringBuf();
		stream.add(jsonDump);
		File.of(outputPath.join('api-dump.json')).writeString(stream.toString());

		return jsonDump;
	}

	public static function getLibraryDir(lib:String):Null<Path>
	{
		try
		{
			var process = new Process('haxelib --global libpath ${lib}');
			if (process.exitCode() != 0)
				return null;

			var output = process.stdout.readAll().toString();
			process.close();

			return Path.of(output);
		}
		catch (e:Dynamic) {}
		return null;
	}

	public static function getUtf8Length(str:String):UInt
	{
		var bytes = haxe.io.Bytes.ofString(str);
		return bytes.length;
	}

	static public function formatBytes(bytes:Float, decimals:Int = 1):String
	{
		if (bytes == 0)
			return "0 bytes";

		var k = 1024;
		var sizes = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
		var i = Math.floor(Math.log(bytes) / Math.log(k));

		if (i == 0)
			return bytes + " bytes";

		var value = bytes / Math.pow(k, i);
		var roundedValue = Math.round(value * Math.pow(10, decimals)) / Math.pow(10, decimals);
		var stringValue = Std.string(roundedValue);

		return stringValue + " " + sizes[i];
	}

	static dynamic function print(v:Dynamic)
		Sys.print(v);

	static dynamic function println(v:Dynamic)
		Sys.println(v);
}
/*
	TAGS:[
		'NotCreatable',
		'NotBrowsable',
		'Deprecated',
		'Service',
		'NotReplicated',
		'PlayerReplicated',
		'Settings',
		'UserSettings'
	]

	CATS:[
		'Instances',
		'Animation',
		'PhysicsParts',
		'GraphicsTexture',
		'Gui',
		'Internal',
		'Script'
	]

	MEM TYPES:[
		'Property',
		'Function',
		'Event',
		'Callback'
	]

	MEM CATS:[
		'Behavior',
		'Data',
		'Transform',
		'State',
		'Appearance',
		'Derived Data',
		'Derived World Data',
		'Tuning',
		'Debug',
		'Shape',
		'Goals',
		'Thrust',
		'Turn',
		'Camera',
		'Image',
		'Physics Response',
		'Drag Directions',
		'Dragged Amount',
		'Mode Switching',
		'Drag Limits',
		'Attachments',
		'AlignOrientation',
		'TargetOrientation',
		'Compliance',
		'AlignmentMode',
		'AlignPosition',
		'Torque',
		'BallSocket',
		'Friction',
		'Limits',
		'TwistLimits',
		'Hinge',
		'Servo',
		'Motor',
		'Derived',
		'LineForce',
		'Line',
		'Plane',
		'Mode',
		'Vector',
		'Rod',
		'Rope',
		'Winch',
		'Slider',
		'Cylinder',
		'AngularServo',
		'AngularLimits',
		'AngularMotor',
		'Spring',
		'Universal',
		'VectorForce',
		'Axes',
		'Balance',
		'Movement',
		'Input',
		'Performance',
		'Errors',
		'Profile',
		'Benchmarking',
		'Control',
		'Mouth',
		'Brows',
		'Eyes',
		'Jaw',
		'Tongue',
		'Video',
		'Localization',
		'Debugging',
		'Selection',
		'Text',
		'Scrolling',
		'Sizing',
		'Jump Settings',
		'Game',
		'Accessories',
		'Scale',
		'Animation',
		'Body Parts',
		'Clothes',
		'Body Colors',
		'Animatable',
		'Exposure',
		'Fog',
		'Material Overrides',
		'Material Pack',
		'Material',
		'Proxy Settings',
		'Diagnostics',
		'Advanced',
		'Parts',
		'Pivot',
		'Part',
		'Assembly',
		'Surface Inputs',
		'Surface',
		'Collision',
		'Teams',
		'Forcefield',
		'AirProperties',
		'Streaming',
		'Networking',
		'Link',
		'Motion',
		'Particles',
		'Emission',
		'Flipbook',
		'EmitterShape',
		'Display',
		'Team',
		'Reflection',
		'General',
		'Cache',
		'RenderingTest',
		'Settings',
		'Output',
		'JobInfo',
		'Asset',
		'Playback',
		'Regions',
		'Emitter',
		'Routing',
		'Character',
		'Mobile',
		'Character Jump Settings',
		'Controls',
		'Script Editor Colors',
		'Tools',
		'Script Editor',
		'Auto-Recovery',
		'Lua Debugger',
		'Directories',
		'Browsing',
		'Primary Part',
		'Audio',
		'Undo',
		'Explorer',
		'Visualization',
		'Configuration',
		'Physics',
		'Results'
	]

	MEM THREAD SAFE:[
		'ReadSafe',
		'Unsafe',
		'Safe'
	]

	MEM TAGS:[
		'ReadOnly',
		'NotReplicated',
		'Hidden',
		'Deprecated',
		'NotBrowsable',
		'CustomLuaState',
		'CanYield',
		'NotScriptable',
		'Yields',
		'NoYield'
	]

	MEM SEC:[
		'Read',
		'Write',
		'None',
		'PluginSecurity',
		'RobloxScriptSecurity',
		'LocalUserSecurity',
		'RobloxSecurity'
	]

	VAL TYPES:[
		'Primitive',
		'Class',
		'DataType',
		'Enum'
	]

	PRIM TYPES:[
		'bool',
		'string',
		'int',
		'int64',
		'float',
		'double'
	]

	DATA TYPES:[
		'Vector3',
		'CFrame',
		'Content',
		'Color3',
		'NumberRange',
		'ColorSequence',
		'NumberSequence',
		'Font',
		'Vector2',
		'BrickColor',
		'Rect',
		'UDim2',
		'Axes',
		'Faces',
		'ProtectedString',
		'PhysicalProperties',
		'Ray',
		'BinaryString',
		'Region3int16',
		'QDir',
		'QFont',
		'DateTime',
		'TweenInfo',
		'UDim'
	]

	GROUP TYPES:[
		'Variant',
		'Dictionary',
		'Array',
		'Tuple',
		'Map'
	]
 */
