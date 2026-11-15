package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The Enum data type represents an individual enum in Roblox. An individual enum can be indexed through the Enums type, via the name of the enum itself.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("Enum")
extern abstract Enum(EnumData)
{
	public static inline function GetEnums():Array<Enum>
		return untyped __lua__("Enum:GetItems()");
}

private extern class EnumData
{
	/**
	 * Returns an array of all EnumItem options available for this enum.
	 */
	@:native("GetEnumItems")
	function getEnumItems<T>():Array<EnumItem<T>>;

	/**
	 * Converts an enum name to an Enum.
	 */
	@:native("FromName")
	function fromName(name:String):Null<Enum>;

	/**
	 * Converts an enum value to an Enum.
	 */
	@:native("FromValue")
	function fromValue(value:Int):Null<Enum>;
}
