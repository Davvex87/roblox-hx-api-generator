package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The Vector2int16 data type represents a vector in 2D space with a signed 16-bit integer for its components. It is similar to Vector2 in that it allows for the same arithmetic operations, but it lacks commonly used vector functions.

	Vector2int16 should not be confused with:
	- Vector2, a more precise and complete implementation for 2D vectors.
	- Vector3int16, a similar implementation for 3D vectors.

	For each component:
	- The lower bound is -2^15, or **-32,768**.
	- The upper bound is 2^15 − 1, or **32,767**.

	@see https://create.roblox.com/docs/reference/engine/datatypes/Vector2int16
**/
@:forward
@:forward.new
@:forwardStatics
@:native("Vector2int16")
extern abstract Vector2int16(Vecctor2int16Data)
{
	@:op(a + b)
	public inline function add(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function div(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} / {1}", this, b);

	@:op(a * b)
	public inline function mulFloat(b:Float):Vector2int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function divFloat(b:Float):Vector2int16
		return untyped __lua__("{0} / {1}", this, b);
}

@:native("Vector2int16")
private extern class Vecctor2int16Data
{
	/**
	 * Returns a Vector2int16 from the given x and y components.
	 */
	function new(x:Int, y:Int);

	/**
	 * The x-coordinate of the Vector2int16.
	 */
	@:native("X")
	var x:Int;

	/**
	 * The y-coordinate of the Vector2int16.
	 */
	@:native("Y")
	var y:Int;
}
