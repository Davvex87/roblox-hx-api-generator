package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

extern class User
{
	static function fromId(domainUserId:Int):User;
	static function fromString(userString:String):User;

	@:native("Id")
	var Id:Int;

	@:native("DomainType")
	var DomainType:DomainType;

	@:native("DomainId")
	var DomainId:Int;

	@:native("ToString")
	function toString():String;
}
