package rblx;

import rlua.Thread;
import haxe.Constraints.Function;

@:native("debug")
extern class Debug
{
	overload static function traceback(message:String, level:Int):String;
	overload static function traceback(thread:Thread, message:String, level:Int):String;
	overload static function info(level:Int, options:String):InfoResult;
	overload static function info(func:Function, options:String):InfoResult;
	overload static function info(thread:Thread, level:Int, options:String):InfoResult;
	static function profilebegin(label:String):Void;
	static function profileend():Void;
	static function getmemorycategory():String;
	static function setmemorycategory(tag:String):String;
	static function resetmemorycategory():Void;
	static function dumpcodesize():Void;
}

@:multiReturn
extern class InfoResult
{
	var first:Dynamic;
	var second:Dynamic;
	var third:Dynamic;
	var fourth:Dynamic;
	var fifth:Dynamic;
}
