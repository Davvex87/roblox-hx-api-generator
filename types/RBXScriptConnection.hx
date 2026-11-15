package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
	The RBXScriptConnection data type is a special object returned by the Connect() method of an event (RBXScriptSignal). This is used primarily to disconnect a listener from an RBXScriptSignal.
**/
@:forward
@:forward.new
@:forwardStatics
@:native("RBXScriptConnection")
extern abstract RBXScriptConnection(RBXScriptConnectionData) {}

@:native("RBXScriptConnection")
private extern class RBXScriptConnectionData
{
	/**
	 * The state of the RBXScriptConnection.
	 */
	@:native("Connected")
	var connected:Bool;

	/**
	 * Disconnects the connection from the event.
	 */
	@:native("Disconnect")
	function disconnect():Void;
}
