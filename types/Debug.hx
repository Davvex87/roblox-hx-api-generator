package rblx;

import rlua.Thread;
import haxe.Constraints.Function;

/**
	Provides a few basic functions for debugging code in Roblox. Unlike the debug library found in Lua natively, this version has been heavily sandboxed.
**/
@:native("debug")
extern class Debug
{
	/**
		Returns a traceback of the current function call stack as a string; in other words, a description of the functions that have been called up to this point. During debugging, this behaves like an error stack trace but does not stop execution of the script.

		The level parameter specifies what level of the call stack to consider, with 1 being the call of debug.traceback() itself, 2 being the call of the function calling debug.traceback(), and so on. See the code sample below for an example of sequential function calls.

		Note that this function will often return inaccurate results (compared to the original source code) and that the format of the returned traceback may change at any time. You should not parse the return value for specific information such as script names or line numbers.

		@see https://create.roblox.com/docs/reference/engine/libraries/debug#traceback
	**/
	overload static function traceback(message:String, level:Int):String;

	/**
		Returns a traceback of the current function call stack as a string; in other words, a description of the functions that have been called up to this point. During debugging, this behaves like an error stack trace but does not stop execution of the script.

		The level parameter specifies what level of the call stack to consider, with 1 being the call of debug.traceback() itself, 2 being the call of the function calling debug.traceback(), and so on. See the code sample below for an example of sequential function calls.

		Note that this function will often return inaccurate results (compared to the original source code) and that the format of the returned traceback may change at any time. You should not parse the return value for specific information such as script names or line numbers.

		@see https://create.roblox.com/docs/reference/engine/libraries/debug#traceback
	**/
	overload static function traceback(thread:Thread, message:String, level:Int):String;

	/**
		Traverses the entire stack of current thread and returns a string containing the call stack of target level details.

		@see https://create.roblox.com/docs/reference/engine/libraries/debug#info
	**/
	overload static function info(level:Int, options:String):InfoResult;

	/**
		Traverses the entire stack of current thread and returns a string containing the call stack of target level details.

		@see https://create.roblox.com/docs/reference/engine/libraries/debug#info
	**/
	overload static function info(func:Function, options:String):InfoResult;

	/**
		Traverses the entire stack of current thread and returns a string containing the call stack of target level details.

		@see https://create.roblox.com/docs/reference/engine/libraries/debug#info
	**/
	overload static function info(thread:Thread, level:Int, options:String):InfoResult;

	/**
		Starts profiling for a label.
	**/
	static function profilebegin(label:String):Void;

	/**
		Stops profiling for the most recent label that debug.profilebegin() opened.
	**/
	static function profileend():Void;

	/**
		Returns the name of the current thread's active memory category.
	**/
	static function getmemorycategory():String;

	/**
		Assigns a custom tag name to the current thread's memory category in the Developer Console. Useful for analyzing memory usage of multiple threads in the same script which would otherwise be grouped together under the same tag/name. Returns the name of the current thread's previous memory category.
	**/
	static function setmemorycategory(tag:String):String;

	/**
		Resets the tag assigned by debug.setmemorycategory() to the automatically assigned value (typically, the script name).
	**/
	static function resetmemorycategory():Void;

	/**
		Displays a table of native code size of individual functions and scripts. This function is only available in the Command Bar in Studio. More details can be found on the Native Code Generation page.
	**/
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
