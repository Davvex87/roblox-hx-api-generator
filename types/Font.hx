package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	Describes the font used to render text. Every font consists of a font family, a weight like Enum.FontWeight.Bold, and a style like Enum.FontStyle.Italic.

	Font families are a type of asset, like images or meshes. Each font family contains a number of font faces, and each face has a different weight and style.

	Font is used by the TextLabel.FontFace, TextButton.FontFace, TextBox.FontFace, and similar properties. See also Enum.Font as an older alternative to this datatype that is required by some methods and properties.

	@see https://create.roblox.com/docs/reference/engine/datatypes/Font
**/
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
