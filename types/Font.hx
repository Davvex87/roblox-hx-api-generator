package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Font")
extern abstract Font(FontData) {}

@:native("Font")
private extern class FontData
{
	/**
	 * Creates a new Font.
	 */
	function new(family:Content, weight:FontWeight, style:FontStyle);

	/**
	 * Creates a Font from an Enum.Font value.
	 */
	static function fromEnum(font:Font):Font;

	/**
	 * Creates a Font from a name like FredokaOne.
	 */
	static function fromName(name:String, weight:FontWeight, style:FontStyle):Font;

	/**
	 * Creates a Font from a numerical asset ID.
	 */
	static function fromId(id:Int, weight:FontWeight, style:FontStyle):Font;

	/**
	 * The asset ID for the font family.
	 */
	@:native("Family")
	var family:Content;

	/**
	 * How thick the text is.
	 */
	@:native("Weight")
	var weight:FontWeight;

	/**
	 * Whether the font is italic.
	 */
	@:native("Style")
	var style:FontStyle;

	/**
	 * Whether the font is bold.
	 */
	@:native("Bold")
	var bold:Bool;
}
