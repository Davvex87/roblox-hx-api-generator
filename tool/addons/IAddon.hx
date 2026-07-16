package addons;

import core.Expr;

interface IAddon
{
	public function buildEnums():Array<EnumData>;
	public function buildClasses():Array<ClassData>;
}
