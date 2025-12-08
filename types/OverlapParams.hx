package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import haxe.extern.EitherType;

@:forward
@:forward.new
@:forwardStatics
@:native("OverlapParams")
extern abstract OverlapParams(OverlapParamsData) {}

@:native("OverlapParams")
private extern class OverlapParamsData
{
	/**
	 * Returns a blank OverlapParams object.
	 */
	function new();

	/**
	 * An array of objects whose descendants is used in filtering candidates.
	 */
	@:native("FilterDescendantsInstances")
	var filterDescendantsInstances:Array<Object>;

	/**
	 * Determines how the OverlapParams.FilterDescendantsInstances list is used.
	 */
	@:native("FilterType")
	var filterType:RaycastFilterType;

	/**
	 * The maximum amount of parts to be returned by the query.
	 */
	@:native("MaxParts")
	var maxParts:Int;

	/**
	 * The collision group used for the operation.
	 */
	@:native("CollisionGroup")
	var collisionGroup:String;

	/**
	 * Determines whether the boundary-querying operation considers a part's BasePart.CanCollide property value over its BasePart CanQuery value.
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
