package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The UDim data type represents a one-dimensional value with two components: a relative scale and an absolute offset in logical pixels. At evaluation time, the engine computes the final pixel value as Scale * referenceMeasurement + Offset, where the reference measurement is typically the size of a parent GuiObject along the corresponding axis.

	UDim values appear individually in properties such as UICorner.CornerRadius, UIPadding.PaddingTop, and UIStroke.Thickness, or paired as a UDim2 for two-dimensional sizing and positioning.

	```lua
	-- 50% of the parent plus 10 extra logical pixels
	local dimension = UDim.new(0.5, 10)
	```
**/
@:forward
@:forward.new
@:forwardStatics
@:native("UDim")
extern abstract UDim(UDimClass)
{
	@:op(a + b)
	public inline function add(b:UDim):UDim
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:UDim):UDim
		return untyped __lua__("{0} - {1}", this, b);
}

@:native("UDim")
private extern class UDimClass
{
	/**
	 * Returns a UDim from the given components.
	 */
	function new(Scale:Float, Offset:Int);

	/**
	 * The relative scale component of the UDim.
	 */
	@:native("Scale")
	var scale:Float;

	/**
	 * The absolute offset component of the UDim.
	 */
	@:native("Offset")
	var offset:Int;
}
