package core;

import utils.ProcessWatch;
import sys.io.File;
import yaml.util.ObjectMap.AnyObjectMap;
import yaml.Parser;
import haxe.ds.StringMap;
import yaml.Yaml;
import sys.FileSystem;
import haxe.io.Path;
import haxe.Exception;

using StringTools;

class DocsParser
{
	public static var classesDocs:StringMap<ParsedClassDocData> = new StringMap();
	public static var enumsDocs:StringMap<ParsedEnumDocData> = new StringMap();

	static var print:Dynamic->Void = Sys.print;
	static var println:Dynamic->Void = Sys.println;

	public static function preload(?printFn:Dynamic->Void, ?printlnFn:Dynamic->Void)
	{
		if (printFn != null)
			print = printFn;
		if (printlnFn != null)
			println = printlnFn;

		var path = cloneDocsRepo();
		println('Loading docs from "${path}"');
		var engineRefPath = Path.join([path, "content", "en-us", "reference", "engine"]);
		if (!FileSystem.exists(engineRefPath) || !FileSystem.isDirectory(engineRefPath))
		{
			println('Could not find engine reference documentation data under "${engineRefPath}", docs comments will not be created');
			return;
		}

		loadYamlDir("classes", Path.join([engineRefPath, "classes"]), (name, rawData) -> classesDocs.set(name, parseClassDocs(rawData)));
		loadYamlDir("enums", Path.join([engineRefPath, "enums"]), (name, rawData) -> enumsDocs.set(name, parseEnumDocs(rawData)));
	}

	static function loadYamlDir(label:String, dirPath:String, onLoad:(String, AnyObjectMap) -> Void)
	{
		if (!FileSystem.exists(dirPath) || !FileSystem.isDirectory(dirPath))
		{
			println('Could not find documentation data under "${dirPath}"');
			return;
		}

		var files = FileSystem.readDirectory(dirPath).filter(f -> Path.extension(f) == "yaml");

		print('Parsing ${label} docs... (0/${files.length})    ');
		for (i => dataPath in files)
		{
			print('\rParsing ${label} docs... (${i + 1}/${files.length})    ');

			var name = Path.withoutExtension(dataPath);
			try
			{
				var fileContent = File.getContent(Path.join([dirPath, dataPath]));

				fileContent = fileContent.replace("—", "-");
				fileContent = fileContent.replace("‑", "-");
				fileContent = fileContent.replace("–", "-");
				fileContent = fileContent.replace("“", "\"");
				fileContent = fileContent.replace("”", "\"");
				fileContent = fileContent.replace("’", "\'");
				fileContent = fileContent.replace("…", "...");

				var rawData:AnyObjectMap = Yaml.parse(fileContent, Parser.options().validate(false));
				onLoad(name, rawData);
			}
			catch (e:Dynamic)
			{
				println('\nFailed to parse docs "${dataPath}": ${e}');
			}
		}
		println('\rParsing ${label} docs... (${files.length}/${files.length})    ');
	}

	static function parseClassDocs(rawData:AnyObjectMap):ParsedClassDocData
	{
		return {
			summary: cleanText(rawData.get("summary")),
			deprecationMessage: cleanText(rawData.get("deprecation_message")),
			properties: parseMembers(rawData.get("properties")),
			methods: parseMembers(rawData.get("methods")),
			events: parseMembers(rawData.get("events")),
			callbacks: parseMembers(rawData.get("callbacks"))
		};
	}

	static function parseEnumDocs(rawData:AnyObjectMap):ParsedEnumDocData
	{
		return {
			summary: cleanText(rawData.get("summary")),
			deprecationMessage: cleanText(rawData.get("deprecation_message")),
			items: parseMembers(rawData.get("items"))
		};
	}

	static function parseMembers(rawList:Dynamic):StringMap<ParsedMemberDocData>
	{
		var out = new StringMap<ParsedMemberDocData>();
		if (!(rawList is Array))
			return out;

		for (rawMember in (rawList : Array<AnyObjectMap>))
		{
			var fullName:Null<String> = rawMember.get("name");
			if (fullName == null)
				continue;

			var parameters = new StringMap<String>();
			var rawParams:Dynamic = rawMember.get("parameters");
			if (rawParams is Array)
			{
				for (rawParam in (rawParams : Array<AnyObjectMap>))
				{
					var paramName:Null<String> = rawParam.get("name");
					var paramSummary = cleanText(rawParam.get("summary"));
					if (paramName != null && paramSummary != null)
						parameters.set(Std.string(paramName), paramSummary);
				}
			}

			var returns:Array<String> = [];
			var rawReturns:Dynamic = rawMember.get("returns");
			if (rawReturns is Array)
			{
				for (rawReturn in (rawReturns : Array<AnyObjectMap>))
				{
					var retSummary = cleanText(rawReturn.get("summary"));
					if (retSummary != null)
						returns.push(retSummary);
				}
			}

			out.set(memberName(fullName), {
				summary: cleanText(rawMember.get("summary")),
				deprecationMessage: cleanText(rawMember.get("deprecation_message")),
				parameters: parameters,
				returns: returns
			});
		}

		return out;
	}

	static function memberName(fullName:String):String
	{
		var idx = Std.int(Math.max(fullName.lastIndexOf("."), fullName.lastIndexOf(":")));
		return idx >= 0 ? fullName.substr(idx + 1) : fullName;
	}

	static final crossRefRegex = ~/`(Class|Datatype|Enum|Global|Library)\.([^`|]+)(?:\|([^`]+))?`/g;
	static final relativeLinkRegex = ~/\[([^\]]+)\]\((?!https?:)[^)]*\)/g;

	static function cleanText(raw:Dynamic):Null<String>
	{
		if (raw == null)
			return null;

		var text = Std.string(raw).replace("\r\n", "\n").trim();
		if (text.length == 0)
			return null;

		text = crossRefRegex.map(text, r ->
		{
			var alias = r.matched(3);
			if (alias != null)
				return '`${alias}`';
			var kind = r.matched(1);
			var target = r.matched(2);
			return kind == "Enum" ? '`Enum.${target}`' : '`${target}`';
		});

		text = relativeLinkRegex.replace(text, "$1");

		return text;
	}

	static function cloneDocsRepo()
	{
		var path = Path.join([Sys.getCwd(), 'creator-docs']);
		if (FileSystem.exists(path))
			return path;

		var cloneProcess = new ProcessWatch("git", [
			"clone",
			"--depth",
			"1",
			"--filter=blob:none",
			"--sparse",
			RobloxExternGenerator.DOCS_REMOTE,
			"creator-docs"
		]);
		cloneProcess.addDefaultListeners();
		var code = cloneProcess.waitExit();
		if (code != 0)
			throw new Exception('Docs repo clone failed');

		var checkoutProcess = new ProcessWatch("git", ["-C", "creator-docs", "sparse-checkout", "set", "content/en-us/reference/engine"]);
		checkoutProcess.addDefaultListeners();
		var code = checkoutProcess.waitExit();
		if (code != 0)
			throw new Exception('Docs repo sparse-checkout failed');

		return path;
	}

	static var curFocus:Null<String>;

	public static function setClassFocus(className:String)
	{
		curFocus = className;
	}

	public static function getClassFocusData():Null<ParsedClassDocData>
	{
		return curFocus != null ? classesDocs.get(curFocus) : null;
	}

	public static function getMemberDocs(memberType:String, name:String):Null<ParsedMemberDocData>
	{
		var classDocs = getClassFocusData();
		if (classDocs == null)
			return null;

		var map = switch (memberType)
		{
			case "Property": classDocs.properties;
			case "Function": classDocs.methods;
			case "Event": classDocs.events;
			case "Callback": classDocs.callbacks;
			default: null;
		}
		return map?.get(name);
	}

	public static function getEnumDocs(enumName:String):Null<ParsedEnumDocData>
	{
		return enumsDocs.get(enumName);
	}
}

typedef ParsedClassDocData =
{
	var summary:Null<String>;
	var deprecationMessage:Null<String>;
	var properties:StringMap<ParsedMemberDocData>;
	var methods:StringMap<ParsedMemberDocData>;
	var events:StringMap<ParsedMemberDocData>;
	var callbacks:StringMap<ParsedMemberDocData>;
}

typedef ParsedEnumDocData =
{
	var summary:Null<String>;
	var deprecationMessage:Null<String>;
	var items:StringMap<ParsedMemberDocData>;
}

typedef ParsedMemberDocData =
{
	var summary:Null<String>;
	var deprecationMessage:Null<String>;
	var parameters:StringMap<String>;
	var returns:Array<String>;
}
