package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The ColorSequenceKeypoint data type represents a single keypoint in a ColorSequence. Each keypoint has a time position between 0 and 1 and a Color3 value that defines the color at that point in the sequence. Properties that use a ColorSequence, such as ParticleEmitter.Color, Beam.Color, and Trail.Color, interpolate linearly between consecutive keypoints in RGB color space.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("ColorSequenceKeypoint")
extern abstract ColorSequenceKeypoint(ColorSequenceKeypointData) {}

@:native("ColorSequenceKeypoint")
private extern class ColorSequenceKeypointData
{
	/**
	 * Returns a ColorSequenceKeypoint from the given time and color.
	 */
	function new(time:Float, color:Color3);

	/**
	 * The relative time at which the keypoint is located.
	 */
	@:native("Time")
	var time:Float;

	/**
	 * The Color3 value of the keypoint.
	 */
	@:native("Value")
	var value:Color3;
}
