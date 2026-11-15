package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	A time-value pair used with ValueCurve instances.

	The Interpolation property dictates the interpolation mode for the segment started by this key and ended by the next key on the curve. Each segment may use a different interpolation mode.

	The LeftTangent and RightTangent properties apply to the cubic interpolation mode and define the desired tangent (slope) at the key. Different left and right values can be used to encode discontinuities in slope at the key. Attempting to set a RightTangent value on a key that doesn't use the cubic interpolation mode will result in a runtime error. It is possible to set the LeftTangent property on any key, as it will be used should the preceding segment use cubic interpolation.
**/
@:native("ValueCurveKey")
extern class ValueCurveKey
{
	/**
		Returns a new ValueCurveKey from the given time and value.
	**/
	function new(time:Float, value:Any, Interpolation:KeyInterpolationMode);

	/**
		The key interpolation mode for the segment started by this ValueCurveKey.
	**/
	@:native("Interpolation")
	var interpolation:KeyInterpolationMode;

	/**
		The time position of this ValueCurveKey.
	**/
	@:native("Time")
	var time:Float;

	/**
		The value of this ValueCurveKey.
	**/
	@:native("Value")
	var value:Any;

	/**
		The tangent to the right of this ValueCurveKey.
	**/
	@:native("RightTangent")
	var rightTangent:Float;

	/**
		The tangent to the left of this ValueCurveKey.
	**/
	@:native("LeftTangent")
	var leftTangent:Float;
}
