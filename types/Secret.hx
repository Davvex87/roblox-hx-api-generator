package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The Secret data type stores the secret content returned by HttpService:GetSecret(). It cannot be printed or logged, but can be modified using built-in functions:
**/
@:forward
@:forward.new
@:forwardStatics
@:native("Secret")
extern abstract Secret(SecretData) {}

@:native("Secret")
private extern class SecretData
{
	/**
	 * Prepends a string to the secret content.
	 */
	@:native("AddPrefix")
	function addPrefix(prefix:String):Secret;

	/**
	 * Appends a string to the secret content.
	 */
	@:native("AddSuffix")
	function addSuffix(suffix:String):Secret;
}
