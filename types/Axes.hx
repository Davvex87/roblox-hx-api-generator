package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import lua.Table;

@:forward
@:forward.new
@:forwardStatics
@:native("Axes")
extern abstract Axes(AxesClass) {}

@:native("Axes")
private extern class AxesClass
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
