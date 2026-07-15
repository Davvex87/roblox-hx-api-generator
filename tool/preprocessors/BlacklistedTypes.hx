package preprocessors;

import core.Expr;

using core.ExprTools;

class BlacklistedTypes implements IPreprocessor
{
	public function new() {}

	public function buildClass(data:ClassData)
	{
		if (data.name == "Studio")
			data.exclude();
	}

	public function buildEnum(data:EnumData) {}
}
