package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The ColorSequence data type represents a gradient of color values from 0 to 1. The color values are expressed using the ColorSequenceKeypoint type. This type is used in various properties of ParticleEmitter, Trail, Beam, and other objects that use color gradients.

	#### Equality
	Two ColorSequence objects are equivalent only if the values of their ColorSequenceKeypoint are equivalent, even if both would result in similar gradients.

	#### Evaluation
	The ColorSequence type does not have a built-in method for getting the value at a certain time/point. However, you can use the following function to evaluate at a specific time.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("ColorSequence")
extern abstract ColorSequence(ColorSequenceData) {}

@:native("ColorSequence")
private extern class ColorSequenceData
{
	/**
	 * Returns a new ColorSequence from an array of ColorSequenceKeypoints.
	 * @param keypoints 
	 * @return ColorSequence
	 */
	function new(keypoints:Array<ColorSequenceKeypoint>);

	/**
	 * Returns a new ColorSequence that is entirely the specified color.
	 * @param c 
	 * @return ColorSequence
	 */
	static function fromColor3(c:Color3):ColorSequence;

	/**
	 * Returns a new ColorSequence with c0 as the start value and c1 as the end value.
	 * @param c0 
	 * @param c1 
	 * @return ColorSequence
	 */
	static function gradient(c0:Color3, c1:Color3):ColorSequence;

	/**
	 * An array of ColorSequenceKeypoint values in ascending order.
	 */
	@:native("Keypoints")
	var keypoints:Array<ColorSequenceKeypoint>;
}
