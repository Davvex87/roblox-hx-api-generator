package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import haxe.extern.EitherType;

/**
	The RaycastParams data type stores parameters for WorldRoot:Raycast() operations. The ExcludeInstances and IncludeInstances properties store a set of objects and their descendants that will be excluded and included from the query. The RaycastParams.IgnoreWater property can be used to ignore Terrain water, and the RaycastParams.CollisionGroup property can specify a collision group for the raycasting operation.

	This object is different from the similarly named RaycastResult which provides the results of a raycast.

	Unlike most data types in Luau, you can change all of the members of RaycastParams without creating a new object, allowing you to reuse the same object repeatedly.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("RaycastParams")
extern abstract RaycastParams(RaycastParamsData) {}

@:native("RaycastParams")
private extern class RaycastParamsData
{
	/**
	 * Returns a blank RaycastParams.
	 */
	function new();

	/**
	 * An array of objects whose descendants are used in filtering raycasting candidates.
	 */
	@:native("FilterDescendantsInstances")
	var filterDescendantsInstances:Array<Object>;

	/**
	 * Determines how the FilterDescendantsInstances array is used.
	 */
	@:native("FilterType")
	var filterType:RaycastFilterType;

	/**
	 * Determines whether the water material is considered when raycasting against Terrain.
	 */
	@:native("IgnoreWater")
	var ignoreWater:Bool;

	/**
	 * The collision group used for the operation.
	 */
	@:native("CollisionGroup")
	var collisionGroup:String;

	/**
	 * Determines whether the raycast operation considers a part's CanCollide property value over its CanQuery value.
	 */
	@:native("RespectCanCollide")
	var respectCanCollide:Bool;

	/**
	 * When enabled, the query will ignore all part collision properties and perform a brute-force check on every part.
	 */
	@:native("BruteForceAllSlow")
	var bruteForceAllSlow:Bool;

	/**
	 * Adds the instances provided to FilterDescendantsInstances.
	 */
	@:native("AddToFilter")
	function addToFilter(instances:EitherType<Instance, Array<Instance>>):Void;
}
