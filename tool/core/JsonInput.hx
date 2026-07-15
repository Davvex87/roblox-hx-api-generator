package core;

import haxe.extern.EitherType;

typedef JsonInput =
{
	var Classes:Array<RblxClassData>;
	var Enums:Array<RblxEnumData>;
	var Version:Int;
}

typedef RblxClassData =
{
	var Members:Array<RblxMember>;
	var MemoryCategory:String;
	var Name:String;
	var Superclass:String;
	var ?Tags:Array<String>;
}

typedef RblxMember =
{
	var ?Category:String;
	var MemberType:String;
	var Name:String;
	var Security:EitherType<RblxSecurity, String>;
	var ?Serialization:RblxSerialization;
	var ?Tags:Array<String>;
	var ThreadSafety:String;
	var ?ValueType:RblxType;
	var ?Parameters:Array<RblxParameter>;
	var ?ReturnType:RblxReturnType;
	var ?Capabilities:EitherType<Array<String>, RblxCapability>;
	var ?SimulationAccess:Bool;
}

typedef RblxSecurity =
{
	var Read:String;
	var Write:String;
}

typedef RblxSerialization =
{
	var CanLoad:Bool;
	var CanSave:Bool;
}

typedef RblxReturnType = EitherType<Array<RblxType>, RblxType>;

typedef RblxType =
{
	var Category:String;
	var Name:String;
}

typedef RblxCapability =
{
	var Read:Array<String>;
	var Write:Array<String>;
}

typedef RblxParameter =
{
	var Name:String;
	var Type:RblxType;
	var ?Default:String;
}

typedef RblxEnumData =
{
	var Name:String;
	var Items:Array<RblxEnumItem>;
	var ?Tags:Array<String>;
}

typedef RblxEnumItem =
{
	var Name:String;
	var Value:Int;
	var ?LegacyNames:Array<String>;
	var ?Tags:Array<String>;
};
