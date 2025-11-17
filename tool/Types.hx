package;

import haxe.ds.Either;

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
	var ?Parameters:Array<ParamArg>;
	var ?ReturnType:ParamTypeObj;
}

typedef ParamArg =
{
	Name:String,
	Type:ParamTypeObj,
	Default:Null<String>
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
