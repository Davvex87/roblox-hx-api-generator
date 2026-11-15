package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The RBXScriptSignal data type, more commonly known as an Event, provides a way for user-defined functions, called listeners, to call when something happens in the game. When an event happens, the RBXScriptSignal fires and calls any listeners that are connected to it. An RBXScriptSignal may also pass arguments to each listener to provide extra information about the event.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("RBXScriptSignal")
extern abstract RBXScriptSignal<T>(RBXScriptSignalData<T>) {}

@:native("RBXScriptSignal")
private extern class RBXScriptSignalData<T>
{
	/**
	 * Connects the given function to the event and returns an RBXScriptConnection that represents it.
	 */
	@:native("Connect")
	function connect(func:T):RBXScriptConnection;

	/**
	 * Connects the given function to the event and returns an RBXScriptConnection that represents it.
	 */
	@:native("ConnectParallel")
	function connectParallel(func:T):RBXScriptConnection;

	/**
	 * Connects the given function to the event (for a single invocation) and returns an RBXScriptConnection that represents it.
	 */
	@:native("Once")
	function once(func:T):RBXScriptConnection;

	/**
	 * Yields the current thread until the signal fires and returns the arguments provided by the signal.
	 */
	@:native("Wait")
	function wait():Variant;
}
