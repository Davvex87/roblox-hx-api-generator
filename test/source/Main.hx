package;

import lua.Math;
import rblx.instances.Attachment;
import rblx.Vector3;
import rblx.CFrame;
import rblx.instances.WeldConstraint;
import rblx.instances.Beam;
import rblx.services.Workspace;

class Main
{
	static function main():Void
	{
		var baseAtt:Attachment = untyped Workspace.MyWeld;
		var newAtt:Attachment = new Attachment();

		newAtt.worldCFrame =
			baseAtt.worldCFrame
			* CFrame.fromOrientation(Math.rad(140), 0, 0)
			+ new Vector3(0.5, 2, 30);

		var b = new Beam();
		b.parent = untyped Workspace;
		b.attachment0 = baseAtt;
		b.attachment1 = newAtt;
	}
}
