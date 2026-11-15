package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	A time-value pair used with RotationCurve instances.

	The Interpolation property dictates the interpolation mode for the segment started by this key and ended by the next key on the curve. Each segment may use a different interpolation mode.

	The LeftTangent and RightTangent properties apply to the cubic interpolation mode and define the desired tangent (slope) at the key. Different left and right values can be used to encode discontinuities in slope at the key. Attempting to set a RightTangent value on a key that doesn't use the cubic interpolation mode will result in a runtime error. It is possible to set the LeftTangent property on any key, as it will be used should the preceding segment use cubic interpolation.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("RotationCurveKey")
extern abstract RotationCurveKey(RotationCurveKeyData) {}

@:native("RotationCurveKey")
private extern class RotationCurveKeyData
{
	/**
	 * Returns a new RotationCurveKey at a given time with a given CFrame.
	 */
	function new(time:Float, cframe:CFrame, Interpolation:KeyInterpolationMode);

	/**
	 * The key interpolation mode for the segment started by this RotationCurveKey.
	 */
	@:native("Interpolation")
	var interpolation:KeyInterpolationMode;

	/**
	 * The time position of this RotationCurveKey.
	 */
	@:native("Time")
	var time:Float;

	/**
	 * The CFrame value of this RotationCurveKey.
	 */
	@:native("Value")
	var value:CFrame;

	/**
	 * The tangent to the right of this RotationCurveKey.
	 */
	@:native("RightTangent")
	var rightTangent:Float;

	/**
	 * The tangent to the left of this RotationCurveKey.
	 */
	@:native("LeftTangent")
	var leftTangent:Float;
}
