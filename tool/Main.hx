package;

import sys.io.Process;
import hx.files.Path;
import haxe.ds.Either;
import hx.files.File;
import hx.files.Dir;
import sys.FileSystem;
import haxe.Json;
import sys.Http;

using hx.strings.Strings;

final ROBLOX_API_ENDPOINT:String = "https://setup.rbxcdn.com/";

class Main
{
	static var outputPath:Path = null;

	static function main()
	{
		Sys.println("Choose your desired output destination folder:");
		Sys.println("  (1) roblox-hx proxy directory");
		Sys.println("  (2) cwd location");
		Sys.println("  (3) custom location");
		Sys.println("  ( ) cancel");
		Sys.print("\n  > ");

		switch (Sys.getChar(true))
		{
			case '1'.code:
				outputPath = getLibraryDir("roblox-hx").join("proxy");
			case '2'.code:
				outputPath = Dir.getCWD().path;
			case '3'.code:
				var inp = Sys.stdin();
				Sys.print("\nPath: ");
				var path = inp.readLine();
				outputPath = Path.of(path.trim());
			default:
				Sys.println("\n\nOPERATION CANCELED!");
				Sys.exit(0);
		}
		if (outputPath == null || !outputPath.exists())
		{
			Sys.stderr().writeString("Unable to locate selected path!");
			Sys.exit(1);
			return;
		}

		Sys.print("\n\nFetching latest API dump... ");

		outputPath.join("rblx").toDir().create();

		var data:Dynamic = Json.parse(fetchDump(null));

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

		parseEnums(data);
		Sys.println("");
		parseClasses(data);
		Sys.println("");
	}

	public static function parseClasses(data:Dynamic)
	{
		outputPath.joinAll(["rblx", "services"]).toDir().create();
		outputPath.joinAll(["rblx", "instances"]).toDir().create();

		var classes:Array<ClassObj> = Reflect.field(data, "Classes");

		var lastLen:UInt = 0;
		for (i in 0...classes.length)
		{
			var cls = classes[i];
			if (cls.Name == "Studio")
				continue;

			Sys.print('\rParsing classes... (${i + 1}/${classes.length}) ${formatBytes(lastLen)}    ');

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
				stream.add('@:native("game:GetService(\'${cls.Name}\')")\n');

			if (objTags.contains("Deprecated"))
				stream.add("@:deprecated\n");

			stream.add('@:rblx${objTags.contains("Service") ? "Service" : "Object"}\n');
			stream.add('extern class ${cls.Name}');
			if (Reflect.hasField(cls, "Superclass") && cls.Superclass != "<<<ROOT>>>")
				stream.add(' extends ${cls.Superclass}');

			stream.add('\n{\n');

			if (pkg.endsWithIgnoreCase("instances") && !objTags.contains("NotCreatable"))
			{
				stream.add('\t@:native("INSTANCE_FACTORY.CREATE_OBJ")\n');
				stream.add('\tpublic extern function new();\n\n');
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
						stream.add('\tpublic extern var ');
						stream.add('${parseName(mem.Name)}${readonly ? '(default, never)' : ''}:${parseType(mem.ValueType)};\n\n');

					case Function:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tpublic extern function ');
						stream.add('${parseName(mem.Name)}(');
						var funcParams:Array<String> = [];
						for (param in mem.Parameters)
							funcParams.push('${parseName(param.Name)}:${parseType(param.Type)}');
						stream.add('${funcParams.join(", ")}):${parseType(mem.ReturnType)};\n\n');

					case Event:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tpublic extern var ');
						stream.add('${parseName(mem.Name)}:RBXScriptSignal<(');
						var funcParams:Array<String> = [];
						for (param in mem.Parameters)
							funcParams.push('${parseName(param.Name)}:${parseType(param.Type)}');
						stream.add('${funcParams.join(", ")})->Void>;\n\n');

					case Callback:
						stream.add('\t@:native("${mem.Name}")\n');
						stream.add('\tpublic extern var ');
						stream.add('${parseName(mem.Name)}:(');
						var funcParams:Array<String> = [];
						for (param in mem.Parameters)
							funcParams.push('${parseName(param.Name)}:${parseType(param.Type)}');
						stream.add('${funcParams.join(", ")})->${parseType(mem.ReturnType)};\n\n');

					default:
						Sys.println('\x1b[33mUnknown member type "${mem.MemberType}", skipping\x1b[0m');
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

		Sys.print('\rParsing classes... (${classes.length}/${classes.length}) ${formatBytes(lastLen)}    ');
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

	static function parseName(str:String)
	{
		var out = str.toLowerCamel();
		if (out == "function" || out == "default" || out == "var" || out == "extern" || out == "class" || out == "enum" || out == "switch"
			|| out == "import" || out == "using" || out == "final" || out == "public" || out == "private" || out == "static" || out == "case"
			|| out == "for" || out == "return" || out == "if" || out == "else" || out == "in" || out == "to" || out == "from" || out == "package"
			|| out == "typedef" || out == "implements" || out == "interface" || out == "operator" || out == "override" || out == "abstract"
			|| out == "break" || out == "continue" || out == "true" || out == "false" || out == "null" || out == "new" || out == "is")
			return '${out}_';
		return out;
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
				n;
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

	public static function parseEnums(data:Dynamic)
	{
		outputPath.joinAll(["rblx", "enums"]).toDir().create();

		var enums:Array<EnumObj> = cast Reflect.field(data, "Enums");
		var lastLen:UInt = 0;
		for (i in 0...enums.length)
		{
			Sys.print('\rParsing enums... (${i + 1}/${enums.length}) ${formatBytes(lastLen)}    ');

			var en = enums[i];
			var stream = new StringBuf();

			stream.add('package rblx.enums;\n\n');
			stream.add('// ADD IMPORTS HERE\n\n');
			stream.add('@:native("Enum.${en.Name}")\n');
			stream.add('@:rblxEnum\n');
			stream.add('extern class ${en.Name}\n{\n');

			for (item in en.Items)
			{
				stream.add('\t@:luaDotMethod @:native("${item.Name}")\n');
				stream.add('\tpublic static extern var ${parseName(item.Name)}:EnumItem;\n\n');
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

		Sys.print('\rParsing enums... (${enums.length}/${enums.length}) ${formatBytes(lastLen)}    ');
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

		Sys.println('($version)');

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
}

typedef ClassObj =
{
	var MemoryCategory:String;
	var Name:String;
	var Superclass:String;
	var Tags:Array<String>;
	var Members:Array<ClassMemberObj>;
}

typedef ClassMemberObj =
{
	var MemberType:MemberType;
	var Name:String;
	var Category:String;
	var ThreadSafety:String;
	var Tags:Array<String>;
	var Security:Either<String, {Read:String, Write:String}>;
	var Serialization:
		{
			CanLoad:Bool,
			CanSave:Bool
		};
	var ?ValueType:ParamTypeObj;
	var ?Parameters:Array<{Name:String, Type:ParamTypeObj}>;
	var ?ReturnType:ParamTypeObj;
}

typedef ParamTypeObj =
{
	Category:ParamTypeCategory,
	Name:String
}

enum abstract MemberType(String) from String to String
{
	var Property:String = "Property";
	var Function:String = "Function";
	var Event:String = "Event";
	var Callback:String = "Callback";
}

enum abstract ParamTypeCategory(String) from String to String
{
	var Primitive:String = "Primitive";
	var Class:String = "Class";
	var DataType:String = "DataType";
	var Enum:String = "Enum";
	var Group:String = "Group";
}

typedef EnumObj =
{
	var Items:Array<EnumItemObj>;
	var Name:String;
}

typedef EnumItemObj =
{
	var Name:String;
	var Value:Int;
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
