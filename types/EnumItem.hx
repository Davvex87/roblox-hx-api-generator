package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
extern abstract EnumItem<T>(EnumItemData<T>) {}

private extern class EnumItemData<T>
{
	/**
	 * The name of the EnumItem.
	 */
	@:native("Name")
	var name:String;

	/**
	 * The integral value assigned to the EnumItem.
	 */
	@:native("Value")
	var value:Int;

	/**
	 * A reference to the parent Enum of the EnumItem.
	 */
	@:native("EnumType")
	var enumType:Enum;

	@:native("IsA")
	function isA(name:String):Bool;
}
