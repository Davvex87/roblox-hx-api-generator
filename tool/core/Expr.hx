package core;

enum FieldKind
{
	Property(d:PropertyData);
	Function(d:FunctionData);
	Event(d:EventData);
	Callback(d:CallbackData);
}

typedef ClassData =
{
	var name:String;
	var superClass:Null<ClassData>;
	var tags:Array<Tag>;
	var memoryCategory:MemoryCategory;
	var fields:Array<FieldKind>;
}

typedef BaseField =
{
	var capabilities:Capabilities;
	var name:String;
	var security:Null<MemberSecurity>;
	var tags:Array<Tag>;
	var threadSafety:ThreadSafety;
}

typedef PropertyData = BaseField &
{
	var category:String;
	var valueType:ValueType;
}

typedef FunctionData = BaseField &
{
	var returnType:ValueType;
	var parameters:Array<Parameter>;
}

typedef EventData = BaseField &
{
	var parameters:Array<Parameter>;
}

typedef CallbackData = BaseField &
{
	var returnType:ValueType;
	var parameters:Array<Parameter>;
}

typedef Parameter =
{
	var name:String;
	var type:ValueType;
	var ?defaultValue:String;
}

typedef Capabilities =
{
	var read:Array<Capability>;
	var write:Array<Capability>;
}

typedef MemberSecurity =
{
	var read:Security;
	var write:Security;
}

enum ValueType
{
	Primitive(n:String);
	Class(n:String);
	Group(n:String);
	DataType(n:String);
	Enum(n:String);
	MultiReturn(v:Array<ValueType>);
}

enum DataType {}

typedef EnumData =
{
	var name:String;
	var items:Array<EnumItem>;
	var tags:Array<Tag>;
}

typedef EnumItem =
{
	var name:String;
	var value:Int;
}

enum MemoryCategory
{
	Animation;
	BaseParts;
	Gui;
	GraphicsTexture;
	Instances;
	Internal;
	Script;
}

enum Tag
{
	CanYield;
	CustomLuaState;
	Deprecated;
	Hidden;
	NoYield;
	NotBrowsable;
	NotReplicated;
	NotScriptable;
	ReadOnly;
	Yields;
	NotCreatable;
	PlayerReplicated;
	Service;
}

// https://create.roblox.com/docs/reference/engine/enums/SecurityCapability
enum Capability
{
	RunClientScript;
	RunServerScript;
	AccessOutsideWrite;
	AssetRequire;
	Deprecated;
	LoadString;
	ScriptGlobals;
	CreateInstances;
	Basic;
	Audio;
	DataStore;
	Network;
	Physics;
	UI;
	CSG;
	Chat;
	Animation;
	Avatar;
	Input;
	Environment;
	RemoteEvent;
	LegacySound;
	Players;
	CapabilityControl;
	Plugin;
	LocalUser;
	WritePlayer;
	RobloxScript;
	RobloxEngine;
	Unassigned;
	InternalTest;
	PluginOrOpenCloud;
	Assistant;
	RemoteCommand;
	AssetRead;
	AssetManagement;
	DynamicGeneration;
	PlatformAvatarEditing;
	AssetCreateUpdate;
	Capture;
	SensitiveInput;
	Monetization;
	LoadOwnedAsset;
	Social;
	ServerCommunication;
	Logging;
	PromptExternalPurchase;
	Groups;
	Teleport;
	Consequences;
	Material;
	AvatarBehavior;
	AvatarAppearance;
	LoadUnownedAsset;
}

enum Security
{
	LocalUserSecurity;
	None;
	NotAccessibleSecurity;
	PluginSecurity;
	RobloxScriptSecurity;
	RobloxSecurity;
}

enum ThreadSafety
{
	ReadSafe;
	Safe;
	Unsafe;
}
