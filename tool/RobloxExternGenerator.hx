package;

import addons.SecurityCapabilitiesAddon;
import core.Expr.ClassData;
import generator.Generator;
import core.ExprParser;
import sys.io.File;
import sys.Http;
import sys.FileSystem;
import mcli.CommandLine;
import mcli.Dispatch;
import haxe.io.Path;
import sys.io.Process;
import preprocessors.*;

using StringTools;
using hx.strings.Strings;
using core.ExprTools;

class RobloxExternGenerator extends CommandLine
{
	static final SOURCE_URL = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/refs/heads/roblox/API-Dump.json";

	static final ADDONS = [new SecurityCapabilitiesAddon()];
	static final PREPROCESSORS = [
		new APIFieldNameFix(),
		new BlacklistedTypes(),
		new MissingOptionals(),
		new NameCollisionFix(),
		new OmitRedefinitionFromSuper()
	];

	/**
		Disable info printing
	**/
	public var quiet:Bool;

	/**
		Answer all questions with yes
	**/
	public var always:Bool;

	/**
		Answer all questions with no
	**/
	public var never:Bool;

	/**
		Output location for the generated extern files
	**/
	public var output:String;

	/**
		Output to roblox-hx library
	**/
	public var lib:Bool;

	/**
		Output to the current working directory
	**/
	public var cwd:Bool;

	/**
		Saves the API-Dump.json file to output path
	**/
	public var save:Bool;

	/**
		Copy base types to output
	**/
	public var types:Bool;

	/**
		Generate service wrapper class
	**/
	public var serviceWrapper:Bool;

	/**
		Show this message.
	**/
	public function help()
	{
		Sys.println(this.showUsage());
		Sys.exit(0);
	}

	public function runDefault()
	{
		if (quiet)
		{
			print = function(v:Dynamic) {};
			println = function(v:Dynamic) {};
		}

		if (output == null && lib == null && cwd == null)
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
					lib = true;
				case '2'.code:
					cwd = true;
				case '3'.code:
					var inp = Sys.stdin();
					Sys.print("\nPath: ");
					var path = inp.readLine();
					output = path.trim();
				default:
					Sys.println("\n\nOPERATION CANCELED!");
					Sys.exit(0);
			}
			Sys.print("\n");
		}

		var targetOutputPath:String;

		if (lib != null)
			targetOutputPath = Path.join([getLibraryDir("roblox-hx"), "src"]);
		else if (cwd != null)
			targetOutputPath = Sys.getCwd();
		else if (output != null)
		{
			if (!FileSystem.exists(output) || !FileSystem.isDirectory(output))
			{
				Sys.stderr().writeString('Output path does not exist or is not a directory: $output\n');
				Sys.exit(1);
			}

			targetOutputPath = output;
		}
		else
		{
			Sys.stderr().writeString('Could not determine output path\n');
			Sys.exit(1);
			return;
		}

		startGenerator(targetOutputPath);

		if (!types)
			types = promptYesNo("Copy types definitions to output?", false);

		if (types)
		{
			var searchPath = Path.join([Path.directory(Sys.programPath()), "types"]);
			if (!FileSystem.exists(searchPath) || !FileSystem.isDirectory(searchPath))
			{
				Sys.stderr().writeString('Types path does not exist or is not a directory: $searchPath\n');
				Sys.exit(1);
			}

			for (path in FileSystem.readDirectory(searchPath))
			{
				if (FileSystem.isDirectory(Path.join([searchPath, path])))
					continue;

				File.copy(Path.join([searchPath, path]), Path.join([targetOutputPath, "rblx", path]));
			}
		}

		println("\n\nDone!");
	}

	function startGenerator(outPath:String)
	{
		println('Generating externs to "${FileSystem.absolutePath(outPath)}"...');
		var jsonDump = fetchDump();
		if (save)
			File.saveContent(Path.join([outPath, "API-Dump.json"]), jsonDump);

		println('Parsing expressions...');

		var parsedData = ExprParser.parseString(jsonDump);

		for (addon in ADDONS)
		{
			parsedData.enums = parsedData.enums.concat(addon.buildEnums());
			parsedData.classes = parsedData.classes.concat(addon.buildClasses());
		}

		var generator = new Generator(PREPROCESSORS);

		var lastLen:UInt = 0;

		print('Parsing classes... (0/${parsedData.classes.length}) ${formatBytes(0)}    ');

		for (i in 0...parsedData.classes.length)
		{
			var classData = parsedData.classes[i];
			print('\rParsing classes... (${i + 1}/${parsedData.classes.length}) ${formatBytes(lastLen)}    ');
			var classOutput = generator.generateClass(classData);
			if (classOutput == null)
				continue;

			var targetDir = Path.join([outPath, "rblx", classData.tags.contains(Service) ? "services" : "instances"]);
			var filePath = Path.join([targetDir, '${classData.name}.hx']);

			if (!FileSystem.exists(targetDir) || !FileSystem.isDirectory(targetDir))
				FileSystem.createDirectory(targetDir);

			File.saveContent(filePath, classOutput);

			lastLen += getUtf8Length(classOutput);
		}

		println('\rParsing classes... (${parsedData.classes.length}/${parsedData.classes.length}) ${formatBytes(lastLen)}    ');

		var lastLen:UInt = 0;
		print('Parsing enums... (0/${parsedData.enums.length}) ${formatBytes(lastLen)}    ');

		for (i in 0...parsedData.enums.length)
		{
			var enumData = parsedData.enums[i];
			print('\rParsing enums... (${i + 1}/${parsedData.enums.length}) ${formatBytes(lastLen)}    ');
			var enumOutput = generator.generateEnum(enumData);
			if (enumOutput == null)
				continue;

			var targetDir = Path.join([outPath, "rblx", "enums"]);
			var filePath = Path.join([targetDir, '${enumData.name}.hx']);

			if (!FileSystem.exists(targetDir) || !FileSystem.isDirectory(targetDir))
				FileSystem.createDirectory(targetDir);

			File.saveContent(filePath, enumOutput);

			lastLen += getUtf8Length(enumOutput);
		}

		println('\rParsing enums... (${parsedData.enums.length}/${parsedData.enums.length}) ${formatBytes(lastLen)}    ');

		if (!serviceWrapper)
			serviceWrapper = promptYesNo("Generate service wrapper class?", false);

		if (serviceWrapper)
		{
			var serviceWrapperStr = getServiceWrapperStr(parsedData.classes);
			File.saveContent(Path.join([outPath, "rblx", "Services.hx"]), serviceWrapperStr);
		}
	}

	function getServiceWrapperStr(classes:Array<ClassData>):String
	{
		var stream = new StringBuf();

		stream.add('package rblx;\n\n');
		stream.add('import rblx.services.*;\n\n');
		stream.add('extern class Services\n{\n');

		for (service in classes.filter(c -> c.tags.contains(Service)))
		{
			if (service.isExcluded())
				continue;

			stream.add('\t@:nativeVariableCode(\"game:GetService(\\\"${service.name}\\\"){accessor}{var}\")\n');
			stream.add('\tpublic static var ${service.name.toLowerCamel()}:${service.name};\n');
		}

		stream.add('}');

		return stream.toString();
	}

	function fetchDump():String
	{
		println('Fetching API-Dump.json from ${SOURCE_URL}...');
		var jsonDump = Http.requestUrl(SOURCE_URL);
		println('Fetched ${formatBytes(getUtf8Length(jsonDump))} of data from dump source');
		return jsonDump;
	}

	function getLibraryDir(lib:String):Null<String>
	{
		try
		{
			var process = new Process('haxelib --global libpath ${lib}');
			if (process.exitCode() != 0)
				return null;

			var output = process.stdout.readAll().toString().replace('\n', '').replace('\r', '').trim();
			process.close();

			return output;
		}
		catch (e:Dynamic) {}
		return null;
	}

	function getUtf8Length(str:String):UInt
	{
		var bytes = haxe.io.Bytes.ofString(str);
		return bytes.length;
	}

	function formatBytes(bytes:Float, decimals:Int = 1):String
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

	function promptYesNo(q:String, defaultToNo = false):Bool
	{
		if (always)
			return true;

		if (never)
			return false;

		Sys.print(q + (defaultToNo ? " (y/N): " : " (Y/n): "));
		var char = Sys.getChar(true);
		Sys.print("\n");
		return !defaultToNo ? !['N'.code, 'n'.code, '0'.code, 'f'.code].contains(char) : ['Y'.code, 'y'.code, '1'.code, 't'.code].contains(char);
	}

	dynamic function print(v:Dynamic)
		Sys.print(v);

	dynamic function println(v:Dynamic)
		Sys.println(v);

	static function main()
	{
		new Dispatch(Sys.args()).dispatch(new RobloxExternGenerator());
	}
}
