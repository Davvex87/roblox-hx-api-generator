package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	A time-value pair used with FloatCurve instances.

	The Interpolation property dictates the interpolation mode for the segment started by this key and ended by the next key on the curve. Each segment may use a different interpolation mode.

	The LeftTangent and RightTangent properties apply to the cubic interpolation mode and define the desired tangent (slope) at the key. Different left and right values can be used to encode discontinuities in slope at the key. Attempting to set a RightTangent value on a key that doesn't use the cubic interpolation mode will result in a runtime error. It is possible to set the LeftTangent property on any key, as it will be used should the preceding segment use cubic interpolation.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("FloatCurveKey")
extern abstract FloatCurveKey(FloatCurveKeyData) {}

@:native("FloatCurveKey")
private extern class FloatCurveKeyData
{
	/**
	 * Returns a new FloatCurveKey from the given time and value.
	 */
	function new(time:Float, value:Float, Interpolation:KeyInterpolationMode);

	/**
	 * The key interpolation mode for the segment started by this FloatCurveKey.
	 */
	@:native("Interpolation")
	var interpolation:KeyInterpolationMode;

	/**
	 * The time position of this FloatCurveKey.
	 */
	@:native("Time")
	var time:Float;

	/**
	 * The value of this FloatCurveKey.
	 */
	@:native("Value")
	var value:Float;

	/**
	 * The tangent to the right of this FloatCurveKey.
	 */
	@:native("RightTangent")
	var rightTangent:Float;

	/**
	 * The tangent to the left of this FloatCurveKey.
	 */
	@:native("LeftTangent")
	var leftTangent:Float;
}
