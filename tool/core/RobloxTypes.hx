package core;

using StringTools;

class RobloxTypes
{
	public static function extract(name:String, isArgument:Bool = false):TypeOut
	{
		var isOptional = false;
		var baseType = name;

		if (name.endsWith("?"))
		{
			isOptional = true;
			baseType = name.substring(0, name.length - 1);
		}

		return {
			type: baseType,
			optional: isOptional
		};
	}

	public static function makeDataType(name:String, isArgument:Bool = false):TypeOut
	{
		var out = extract(name, isArgument);

		if (out.type.toLowerCase() == "optionalcoordinateframe")
			out.optional = true;

		out.type = switch (out.type.toLowerCase())
		{
			case "binarystring": "Dynamic";
			case "contentid": "String";
			case "coordinateframe": "CFrame";
			case "clipevaluator": "Dynamic";
			case "function": "haxe.Constraints.Function";
			case "instances": "Array<Instance>";
			case "opencloudmodel": "Dynamic";
			case "optionalcoordinateframe": "CFrame";
			case "protectedstring": "String";
			case "qdir": "Dynamic";
			case "qfont": "Dynamic";
			case "uniqueid": "Int";
			case "webviewparams": "Dynamic";
			case "buffer": "Buffer";
			case "rbxscriptsignal": "RBXScriptSignal<haxe.Constraints.Function>";

			default: out.type;
		}

		return out;
	}

	public static function makeGroupType(name:String, isArgument:Bool = false):TypeOut
	{
		var out = extract(name, isArgument);

		out.type = switch (out.type.toLowerCase())
		{
			case "array": "Array<Dynamic>";
			case "dictionary": "Map<String, Dynamic>";
			case "map": "Map<Dynamic, Dynamic>";
			case "tuple": isArgument ? "Rest<Dynamic>" : "Dynamic"; // TODO: multi return
			case "variant": "Dynamic";

			default:
				throw 'Unknown group type $name';
		}

		return out;
	}

	public static function makePrimitiveType(name:String, isArgument:Bool = false):TypeOut
	{
		var out = extract(name, isArgument);

		out.type = switch (out.type.toLowerCase())
		{
			case "bool": "Bool";
			case "double": "Float";
			case "float": "Float";
			case "int": "Int";
			case "int64": "Int";
			case "null": "Void";
			case "string": "String";

			default:
				throw 'Unknown primitive type $name';
		}

		return out;
	}
}

typedef TypeOut =
{
	var type:String;
	var optional:Bool;
}
