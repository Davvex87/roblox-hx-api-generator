package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("NumberSequenceKeypoint")
extern abstract NumberSequenceKeypoint(NumberSequenceKeypointData) {}

@:native("NumberSequenceKeypoint")
private extern class NumberSequenceKeypointData
{
	/**
	 * Returns a keypoint with the specified time, value, and envelope (optional).
	 */
	function new(time:Float, value:Float, ?envelope:Float);

	/**
	 * The amount of variance allowed from the value.
	 */
	@:native("Envelope")
	var envelope:Float;

	/**
	 * The relative time at which the keypoint is positioned.
	 */
	@:native("Time")
	var time:Float;

	/**
	 * The base value of the keypoint.
	 */
	@:native("Value")
	var value:Float;
}
