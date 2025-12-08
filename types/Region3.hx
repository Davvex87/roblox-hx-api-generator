package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Region3")
extern abstract Region3(Region3Data) {}

@:native("Region3")
private extern class Region3Data
{
	/**
	 * Returns a new Region3 using the provided vectors as boundaries.
	 */
	function new(min:Vector3, max:Vector3);

	/**
	 * The center location and rotation of the Region3.
	 */
	@:native("CFrame")
	var cFrame:CFrame;

	/**
	 * The 3D size of the Region3.
	 */
	@:native("Size")
	var size:Vector3;

	/**
	 * Expands the Region3 to fit a grid based on the provided resolution.
	 */
	@:native("ExpandToGrid")
	function expandToGrid(resolution:Int):Region3;
}
