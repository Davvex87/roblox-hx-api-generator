package rblx;

import haxe.extern.EitherType;
import haxe.Constraints.Function;
import rlua.Thread;

/**
	The task library allows for functions and threads to be scheduled with the engine's scheduler.

	The functions available in this library generally support functions and threads. In most cases using a function is sufficient, but for more advanced cases it's recommended you familiarize yourself with the coroutine library.
**/
@:native("task")
extern class Task
{
	/**
		Calls/resumes a function/coroutine immediately through the engine's scheduler.
	**/
	static function spawn(functionOrThread:EitherType<Function, Thread>, ...args:Dynamic):Thread;

	/**
		Calls/resumes a function/coroutine at the end of the current resumption cycle.
	**/
	static function defer(functionOrThread:EitherType<Function, Thread>, ...args:Dynamic):Thread;

	/**
		Schedules a function/coroutine to be called/resumed on the next Heartbeat after the given duration (in seconds) has passed, without throttling.
	**/
	static function delay(duration:Float, functionOrThread:EitherType<Function, Thread>, ...args:Dynamic):Thread;

	/**
		Causes the following code to be run in parallel.

		@see https://create.roblox.com/docs/scripting/multithreading
	**/
	static function desynchronize():Void;

	/**
		Causes the following code to be run in serial.

		@see https://create.roblox.com/docs/scripting/multithreading
	**/
	static function synchronize():Void;

	/**
		Yields the current thread without throttling.
	**/
	static function wait(duration:Float):Float;

	/**
		Cancels a thread, preventing it from being resumed.
	**/
	static function cancel(thread:Thread):Void;
}
