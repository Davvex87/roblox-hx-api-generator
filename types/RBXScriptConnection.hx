package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

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
