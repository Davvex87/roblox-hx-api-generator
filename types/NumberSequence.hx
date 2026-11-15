package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The NumberSequence data type represents a series of number values from 0 to 1. The number values are expressed using the NumberSequenceKeypoint type. This type is used in properties such as ParticleEmitter.Size and Beam.Transparency to define a numerical change over time.

	#### Equality
	Two NumberSequence objects are equivalent only if the values of their NumberSequenceKeypoint are equivalent, even if both would result in similar graphs.

	#### Evaluation
	The NumberSequence type does not have a built-in method for getting the value at a certain time/point because keypoints can have random envelopes. However, assuming the envelope values of your keypoints are all 0, you can use the following function to evaluate at a specific time.
**/
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
