package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The NumberRange represents a range of numbers.

	NumberRange stores its NumberRange.Min and NumberRange.Max values as 32-bit floating-point numbers. Very large numbers or numbers requiring high decimal precision may lose accuracy.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("NumberRange")
extern abstract NumberRange(NumberRangeData) {}

@:native("NumberRange")
private extern class NumberRangeData
{
	/**
	 * Returns a new NumberRange with the minimum and maximum set to the value.
	 */
	@:native("new")
	static function fromValue(value:Float):NumberRange;

	/**
	 * Returns a new NumberRange with the provided minimum and maximum.
	 */
	function new(minimum:Float, maximum:Float);

	/**
	 * The minimum value of the NumberRange.
	 */
	@:native("Min")
	var min:Float;

	/**
	 * The maximum value of the NumberRange.
	 */
	@:native("Max")
	var max:Float;
}
