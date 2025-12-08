package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import rblx.Color3;

@:forward
@:forward.new
@:forwardStatics
@:native("BrickColor")
extern abstract BrickColor(BrickColorClass)
{
	@:from
	public static inline function fromInt(value:Int):BrickColor
		return BrickColorClass.fromValue(value);

	@:to
	public inline function toInt():Int
	{
		return (Math.round(this.r * 255) << 16) | (Math.round(this.g * 255) << 8) | Math.round(this.b * 255);
	}

	@:from
	public static inline function fromColor3(color:Color3):BrickColor
		return BrickColorClass.fromColor3(color);

	@:to
	public inline function toColor3():Color3
		return this.color;
}

@:native("BrickColor")
private extern class BrickColorClass
{
	/**
	 * Constructs a BrickColor from its palette index.
	 */
	static function palette(paletteValue:Int):BrickColor;

	/**
	 * Returns a random BrickColor.
	 */
	static function random():BrickColor;

	/**
	 * Returns the "White" BrickColor.
	 */
	@:native("White")
	static function white():BrickColor;

	/**
	 * Returns the "Medium stone grey" BrickColor.
	 */
	@:native("Gray")
	static function gray():BrickColor;

	/**
	 * Returns the "Dark stone grey" BrickColor.
	 */
	@:native("DarkGray")
	static function darkGray():BrickColor;

	/**
	 * Returns the "Black" BrickColor.
	 */
	@:native("Black")
	static function black():BrickColor;

	/**
	 * Returns the "Bright Red" BrickColor.
	 */
	@:native("Red")
	static function red():BrickColor;

	/**
	 * Returns the "Bright Yellow" BrickColor.
	 */
	@:native("Yellow")
	static function yellow():BrickColor;

	/**
	 * Returns the "Dark Green" BrickColor.
	 */
	@:native("Green")
	static function green():BrickColor;

	/**
	 * Returns the "Bright Blue" BrickColor.
	 */
	@:native("Blue")
	static function blue():BrickColor;

	/**
	 * Constructs a BrickColor from its name.
	 */
	function new(name:String);

	/**
	 * Constructs a BrickColor from its numerical index.
	 */
	@:native("new")
	static function fromValue(val:Int):BrickColor;

	/**
	 * Constructs the closest BrickColor that can be matched to the specified RGB components, each between 0 and 1.
	 */
	@:native("new")
	static function fromRGB(r:Float, g:Float, b:Float):BrickColor;

	/**
	 * Constructs the closest BrickColor that can be matched to the specified Color3.
	 */
	@:native("new")
	static function fromColor3(color:Color3):BrickColor;

	/**
	 * The unique number that identifies the BrickColor.
	 */
	@:native("Number")
	var number:Float;

	/**
	 * The red component of the BrickColor (between 0 and 1).
	 */
	var r:Float;

	/**
	 * The green component of the BrickColor (between 0 and 1).
	 */
	var g:Float;

	/**
	 * The blue component of the BrickColor (between 0 and 1).
	 */
	var b:Float;

	/**
	 * The name associated with the BrickColor.
	 */
	@:native("Name")
	var name:String;

	/**
	 * The Color3 associated with the BrickColor.
	 */
	@:native("Color")
	var color:Color3;
}
