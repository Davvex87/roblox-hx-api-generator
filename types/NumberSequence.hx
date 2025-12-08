package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("NumberSequence")
extern abstract NumberSequence(NumberSequenceData) {}

@:native("NumberSequence")
private extern class NumberSequenceData
{
	/**
	 * Returns a NumberSequence with the start and end values set to the provided n.
	 */
	static function fromValue(n:Float):NumberSequence;

	/**
	 * Returns a NumberSequence of two keypoints with n0 as the start value and n1 as the end value.
	 */
	static function fromGradient(n0:Float, n1:Float):NumberSequence;

	/**
	 * Returns a NumberSequence from an array of NumberSequenceKeypoints.
	 */
	function new(Keypoints:Array<NumberSequenceKeypoint>);

	/**
	 * An array of NumberSequenceKeypoint values in ascending order.
	 */
	@:native("Keypoints")
	var keypoints:Array<NumberSequenceKeypoint>;
}
