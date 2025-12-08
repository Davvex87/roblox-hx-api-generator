package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Faces")
extern abstract Faces(FacesData) {}

@:native("Faces")
private extern class FacesData
{
	/**
	 * Returns a Faces with the corresponding face of each passed Enum.NormalId as true.
	 */
	function new(...normalIds:NormalId);

	/**
	 * Whether the top face is included.
	 */
	@:native("Top")
	var top:Bool;

	/**
	 * Whether the bottom face is included.
	 */
	@:native("Bottom")
	var bottom:Bool;

	/**
	 * Whether the left face is included.
	 */
	@:native("Left")
	var left:Bool;

	/**
	 * Whether the right face is included.
	 */
	@:native("Right")
	var right:Bool;

	/**
	 * Whether the back face is included.
	 */
	@:native("Back")
	var back:Bool;

	/**
	 * Whether the front face is included.
	 */
	@:native("Front")
	var front:Bool;
}
