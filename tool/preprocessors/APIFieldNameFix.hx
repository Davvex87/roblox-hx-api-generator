package preprocessors;

import generator.Generator;
import core.Expr;

using core.ExprTools;
using StringTools;

class APIFieldNameFix implements IPreprocessor
{
	public function new() {}

	public function buildClass(data:ClassData)
	{
		for (field in data.fields)
		{
			var baseField = Generator.instance.extractBaseField(field);
			baseField.name = baseField.name.replace(" ", "");
		}
	}

	public function buildEnum(data:EnumData) {}
}
