package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	A time-value pair used with ValueCurve instances.
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
