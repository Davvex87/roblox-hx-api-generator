package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import lua.Table;

/**
	The Axes data type contains a set of enabled 3D axes, represented as a bitmask. It is used by the ArcHandles class through its Axes property to control which rotation arc handles are visible.

	Axes exposes three axis properties (X, Y, Z) and six face properties (Top, Bottom, Left, Right, Front, Back). Because faces map to their corresponding axis, face pairs always share the same value: Top and Bottom both reflect the Y axis, Left and Right both reflect the X axis, and Front and Back both reflect the Z axis.

	Like most data types on Roblox, the Axes data type is immutable: you cannot assign to its properties once created.
**/
@:native("Axes")
extern class Axes
{
	/**
	 * Creates a new Axes using list of axes and/or faces. NormalIds (faces) are converted to the corresponding axes.
	 */
	function new(...axes:NormalId);

	/**
	 * Whether the X axis is enabled.
	 */
	@:native("X")
	var x:Bool;

	/**
	 * Whether the Y axis is enabled.
	 */
	@:native("Y")
	var y:Bool;

	/**
	 * Whether the Z axis is enabled.
	 */
	@:native("Z")
	var z:Bool;

	/**
	 * Whether the top face is included.
	 */
	@:native("Top")
	var top:Bool;

	/**
	 * Whether the bottom face is included.
	 */
	@:native("Bottom")
	var bottom:Bool;

	/**
	 * Whether the left face is included.
	 */
	@:native("Left")
	var left:Bool;

	/**
	 * Whether the right face is included.
	 */
	@:native("Right")
	var right:Bool;

	/**
	 * Whether the back face is included.
	 */
	@:native("Back")
	var back:Bool;

	/**
	 * Whether the front face is included.
	 */
	@:native("Front")
	var front:Bool;
}
