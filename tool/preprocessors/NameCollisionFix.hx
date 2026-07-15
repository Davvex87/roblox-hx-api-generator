package preprocessors;

import generator.Generator;
import core.Expr;

using core.ExprTools;

class NameCollisionFix implements IPreprocessor
{
	public function new() {}

	public function buildClass(data:ClassData)
	{
		for (field in data.fields)
		{
			var baseField = Generator.instance.extractBaseField(field);
			if (baseField.isExcluded())
				continue;

			if (baseField.tags.contains(Deprecated))
			{
				var haxeName = Generator.instance.parseName(baseField.name);
				if (data.fields.filter(f ->
				{
					var b = Generator.instance.extractBaseField(f);
					return b != baseField && Generator.instance.parseName(b.name) == haxeName;
				}).length > 0)
					baseField.exclude();
			}
		}
	}

	public function buildEnum(data:EnumData) {}
}
