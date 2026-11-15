package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The Faces data type contains six booleans representing whether a feature is enabled for each face (Enum.NormalId) of a Part. In other words, this contains a boolean for each axes (X/Y/Z) in both directions (positive/negative). The Handles object uses this data type to enable whether a direction has a visible handle on a Part's face.

	```lua
	local handles = Instance.new("Handles")
	handles.Faces = Faces.new(Enum.NormalId.Front, Enum.NormalId.Left)
	```

	Like most data types on Roblox, the Faces data type is immutable and you cannot assign to its properties once created.
**/
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
