package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

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
