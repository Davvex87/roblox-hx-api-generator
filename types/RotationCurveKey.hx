package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

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
