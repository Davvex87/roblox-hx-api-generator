package preprocessors;

import generator.Generator;
import core.Expr;

using core.ExprTools;

class OmitRedefinitionFromSuper implements IPreprocessor
{
	public function new() {}

	public function buildClass(data:ClassData)
	{
		function getFieldNames(cls:ClassData):Array<String>
		{
			var names:Array<String> = [];
			if (cls.superClass != null)
				names = names.concat(getFieldNames(cls.superClass));
			names = names.concat(cls.fields.map(f -> Generator.instance.extractBaseField(f).name));
			return names;
		}
		var superClassFieldNames:Array<String> = data.superClass != null ? getFieldNames(data.superClass) : [];
		for (field in data.fields)
		{
			if (superClassFieldNames.contains(Generator.instance.extractBaseField(field).name))
				Generator.instance.extractBaseField(field).exclude();
		}
	}

	public function buildEnum(data:EnumData) {}
}
