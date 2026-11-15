package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	Not to be confused with Region3, a separate class that fulfills a different purpose.

	The Region3int16 data type represents a volume in 3D space similar to an axis-aligned rectangular prism. It uses two Vector3int16 to store the volume's bounds in the Min and Max properties. It is constructed using Region3int16.new(Min, Max), given the two Vector3int16 bounds. This data type features no functions or operations.

	#### Calculating Center and Size
	This data type differs from Region3 in that it stores its bounds directly, rather than through a center and size combination. Nonetheless, it is possible to calculate these dimensions using Min and Max:

	#### Conversion to Region3
	The following function can be used to convert a Region3int16 into a similar Region3. It does this by converting the Min and Max properties, which are Vector3int16, into Vector3 used with Region3.new().

	@see https://create.roblox.com/docs/reference/engine/datatypes/Region3
**/
@:forward
@:forward.new
@:forwardStatics
@:native("Region3int16")
extern abstract Region3int16(Region3int16Data) {}

@:native("Region3int16")
private extern class Region3int16Data
{
	/**
	 * Returns a new Region3int16 from the provided boundaries.
	 */
	function new(min:Vector3int16, max:Vector3int16);

	/**
	 * The lower bound of the Region3int16.
	 */
	@:native("Min")
	var min:Vector3int16;

	/**
	 * The upper bound of the Region3int16.
	 */
	@:native("Max")
	var max:Vector3int16;
}
