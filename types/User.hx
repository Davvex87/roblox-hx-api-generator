package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The User data type represents a user's scoped identity within a specific domain, such as an experience or OAuth application. It encapsulates a domain user ID alongside the domain metadata that uniquely identifies that user within that domain.

	Unlike a numeric user ID alone, a User value carries its domain context, making it unambiguous across experiences and apps. It is the standard identifier for referencing users in new experience code and is available from Player.User.
**/
extern class User
{
	/**
		Creates a User from a domain user ID within the current experience.
	**/
	static function fromId(domainUserId:Int):User;

	/**
		Creates a User from its serialized string form.


	**/
	static function fromString(userString:String):User;

	/**
		The domain user ID, unique within this domain.
	**/
	@:native("Id")
	var Id:Int;

	/**
		The type of domain that this domain user ID belongs to.
	**/
	@:native("DomainType")
	var DomainType:DomainType;

	/**
		The identifier of the specific domain instance.
	**/
	@:native("DomainId")
	var DomainId:Int;

	/**
		Serializes this User into a stable string representation.
	**/
	@:native("ToString")
	function toString():String;
}
