package rblx;

import rblx.instances.*;
import rblx.enums.*;
import rblx.services.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Content")
extern abstract Content(ContentData)
{
	@:from
	public static function fromString(s:String):Content
		return Content.fromUri(s);

	@:from
	public static function fromInt(i:Int):Content
		return Content.fromUri('rbxasset://$i');
}

@:native("Content")
private extern class ContentData
{
	/**
	 * Returns a new Content with an asset URI string value referencing content external to the place.
	 * @param uri 
	 */
	static function fromUri(uri:String):Content;

	/**
	 * Returns a new Content with a strong reference to an Object.
	 */
	static function fromObject(object:Object):Content;

	/**
	 * An empty Content value with Content.SourceType of None.
	 */
	var none:Content;

	/**
	 * The source type of the contained value.
	 */
	@:native("SourceType")
	var sourceType:ContentSourceType;

	/**
	 * A URI string if Content.SourceType is Uri, otherwise nil.
	 */
	@:native("Uri")
	var uri:Null<String>;

	/**
	 * A reference to a non-nil Object if Content.SourceType is Object, otherwise nil.
	 */
	@:native("Object")
	var object:Null<Int>;

	/**
	 * A reference to a non-nil Opaque content if Content.SourceType is Opaque, otherwise nil.
	 */
	@:native("Opaque")
	var opaque:Null<Int>;
}
