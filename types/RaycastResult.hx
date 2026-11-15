package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The RaycastResult data type stores the result of a successful raycasting operation performed by WorldRoot:Raycast(). It contains the properties listed below.

	This object should not be confused with the similarly-named RaycastParams which is used to perform a raycast.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("RaycastResult")
extern abstract RaycastResult(RaycastResultData) {}

@:native("RaycastResult")
private extern class RaycastResultData
{
	/**
	 * The distance between the ray origin and the intersection point.
	 */
	@:native("Distance")
	var distance:Float;

	/**
	 * The BasePart or Terrain cell that the ray intersected.
	 */
	@:native("Instance")
	var instance:BasePart;

	/**
	 * The Enum.Material at the intersection point.
	 */
	@:native("Material")
	var material:Material;

	/**
	 * The world space point at which the intersection occurred.
	 */
	@:native("Position")
	var position:Vector3;

	/**
	 * The normal vector of the intersected face.
	 */
	@:native("Normal")
	var normal:Vector3;
}
