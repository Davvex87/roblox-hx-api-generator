package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The Vector3int16 data type represents a vector in 3D space with a signed 16-bit integer for its components. It is similar to Vector3 in that it allows for the same arithmetic operations, but it lacks commonly used vector functions.

	Vector3int16 should not be confused with:
	- Vector3, a more precise and complete implementation for 3D vectors.
	- Vector2int16, a similar implementation for 2D vectors.

	For each component:
	- The lower bound is -2^15, or **-32,768**.
	- The upper bound is 2^15 − 1, or **32,767**.

	@see https://create.roblox.com/docs/reference/engine/datatypes/Vector3int16
**/
@:forward
@:forward.new
@:forwardStatics
@:native("Vector3int16")
extern abstract Vector3int16(Vecctor3int16Data)
{
	@:op(a + b)
	public inline function add(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function div(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} / {1}", this, b);

	@:op(a * b)
	public inline function mulFloat(b:Float):Vector3int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function divFloat(b:Float):Vector3int16
		return untyped __lua__("{0} / {1}", this, b);
}

@:native("Vector3int16")
private extern class Vecctor3int16Data
{
	/**
	 * Returns a new Vector3int16 from the given x, y, and z components.
	 */
	function new(x:Int, y:Int, z:Int);

	/**
	 * The x-coordinate of the Vector3int16.
	 */
	@:native("X")
	var x:Int;

	/**
	 * The y-coordinate of the Vector3int16.
	 */
	@:native("Y")
	var y:Int;

	/**
	 * The z-coordinate of the Vector3int16.
	 */
	@:native("Z")
	var z:Int;
}
