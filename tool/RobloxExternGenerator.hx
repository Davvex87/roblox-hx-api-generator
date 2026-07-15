package;

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

class RobloxExternGenerator extends CommandLine
{
	static final SOURCE_URL = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/refs/heads/roblox/API-Dump.json";
	static final PREPROCESSORS = [new BlacklistedTypes(), new MissingOptionals()];

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
		Saves the API-Dump.json file to the output location
	**/
	public var save:Bool;

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
		}

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

		if (lib != null)
			startGenerator(Path.join([getLibraryDir("roblox-hx"), "src"]));
		else if (cwd != null)
			startGenerator(Sys.getCwd());
		else if (output != null)
		{
			if (!FileSystem.exists(output) || !FileSystem.isDirectory(output))
			{
				Sys.stderr().writeString('Output path does not exist or is not a directory: $output\n');
				Sys.exit(1);
			}

			startGenerator(output);
		}

		println("\n\nDone!");
	}

	public function startGenerator(outPath:String)
	{
		var jsonDump = fetchDump();
		if (save)
			File.saveContent(Path.join([outPath, "API-Dump.json"]), jsonDump);

		println('Parsing expressions...');

		var parsedData = ExprParser.parseString(jsonDump);
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

			var filePath = Path.join([
				outPath,
				"rblx",
				classData.tags.contains(Service) ? "services" : "instances",
				'${classData.name}.hx'
			]);

			FileSystem.createDirectory(Path.directory(filePath));
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

			var filePath = Path.join([outPath, "rblx", "enums", '${enumData.name}.hx']);

			FileSystem.createDirectory(Path.directory(filePath));
			File.saveContent(filePath, enumOutput);

			lastLen += getUtf8Length(enumOutput);
		}

		println('\rParsing enums... (${parsedData.enums.length}/${parsedData.enums.length}) ${formatBytes(lastLen)}    ');
	}

	public function fetchDump():String
	{
		println('Fetching API-Dump.json from ${SOURCE_URL}...');
		var jsonDump = Http.requestUrl(SOURCE_URL);
		println('Fetched ${formatBytes(getUtf8Length(jsonDump))} of data from dump source');
		return jsonDump;
	}

	public function getLibraryDir(lib:String):Null<String>
	{
		try
		{
			var process = new Process('haxelib --global libpath ${lib}');
			if (process.exitCode() != 0)
				return null;

			var output = process.stdout.readAll().toString();
			process.close();

			return output;
		}
		catch (e:Dynamic) {}
		return null;
	}

	public function getUtf8Length(str:String):UInt
	{
		var bytes = haxe.io.Bytes.ofString(str);
		return bytes.length;
	}

	public function formatBytes(bytes:Float, decimals:Int = 1):String
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

	dynamic function print(v:Dynamic)
		Sys.print(v);

	dynamic function println(v:Dynamic)
		Sys.println(v);

	static function main()
	{
		new Dispatch(Sys.args()).dispatch(new RobloxExternGenerator());
	}
}
