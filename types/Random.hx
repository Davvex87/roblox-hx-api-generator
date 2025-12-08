package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import lua.Table;

@:forward
@:forward.new
@:forwardStatics
@:native("Random")
extern abstract Random(RandomData) {}

@:native("Random")
private extern class RandomData
{
	/**
	 * Returns a new pseudorandom generator using an optional seed.
	 */
	function new(seed:Float);

	/**
	 * Returns a pseudorandom integer uniformly distributed over [min, max].
	 */
	@:native("NextInteger")
	function nextInteger(min:Int, max:Int):Int;

	/**
	 * Returns a pseudorandom number uniformly distributed over [min, max].
	 */
	@:native("NextNumber")
	function nextNumber(?min:Float, ?max:Float):Float;

	/**
	 * Uniformly shuffles a table in-place.
	 */
	@:native("Shuffle")
	function shuffle(tb:AnyTable):Void;

	/**
	 * Returns a unit vector with a pseudorandom direction.
	 */
	@:native("NextUnitVector")
	function nextUnitVector():Vector3;

	/**
	 * Returns a new Random object with the same state as the original.
	 */
	@:native("Clone")
	function clone():Random;
}
