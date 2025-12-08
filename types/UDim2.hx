package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("UDim2")
extern abstract UDim2(UDim2Class)
{
	@:op(a + b)
	public inline function add(b:UDim2):UDim2
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a - b)
	public inline function sub(b:UDim2):UDim2
		return untyped __lua__("{0} * {1}", this, b);
}

@:native("UDim2")
private extern class UDim2Class
{
	/**
	 * Returns a new UDim2 with the coordinates of two zero UDim components representing each axis.
	 * @return UDim2
	 */
	@:native("new")
	static function zero():UDim2;

	/**
	 * Returns a new UDim2 given the coordinates of the two UDim components representing each axis.
	 */
	function new(xScale:Float, xOffset:Int, yScale:Float, yOffset:Int);

	/**
	 * Returns a new UDim2 from the given UDim objects representing the X and Y dimensions, respectively.
	 */
	@:native("new")
	static function fromUDim(x:UDim, y:UDim):UDim2;

	/**
	 * Returns a new UDim2 with the given scale components and no offsets.
	 */
	static function fromScale(xScale:Float, yScale:Float):UDim2;

	/**
	 * Returns a new UDim2 with the given offset components and no scaling.
	 */
	static function fromOffset(xOffset:Int, yOffset:Int):UDim2;

	/**
	 * The X dimension scale and offset of the UDim2.
	 */
	@:native("X")
	var x:UDim;

	/**
	 * The Y dimension scale and offset of the UDim2.
	 */
	@:native("Y")
	var y:UDim;

	/**
	 * The X dimension scale and offset of the UDim2.
	 */
	@:native("Width")
	var width:UDim;

	/**
	 * The Y dimension scale and offset of the UDim2.
	 */
	@:native("Height")
	var height:UDim;

	/**
	 * Returns a UDim2 interpolated linearly between the value and the given goal.
	 */
	@:native("Lerp")
	function lerp(goal:UDim2, alpha:Float):UDim2;
}
