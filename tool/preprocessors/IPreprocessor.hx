package preprocessors;

import core.Expr;

interface IPreprocessor
{
	public function buildEnum(data:EnumData):Void;
	public function buildClass(data:ClassData):Void;
}
