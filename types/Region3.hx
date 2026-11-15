package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The Region3 data type describes a volume in 3D space similar to an axis-aligned rectangular prism. It is commonly used with Terrain functions and functions that detect parts within a volume, such as WorldRoot:FindPartsInRegion3().

	The prism's center is accessible using the Region3.CFrame property and the prism's size is accessible through the Region3.Size property. Note that the components of this property may be negative.

	The Region3:ExpandToGrid() method returns a new Region3 whose bounds comply with a provided resolution value. The resulting volume may be equal to or greater than the original volume, but never smaller.

	@see https://create.roblox.com/docs/reference/engine/datatypes/Region3int16
**/
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
