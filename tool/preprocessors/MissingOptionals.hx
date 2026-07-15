package preprocessors;

import core.Expr;

using core.ExprTools;

class MissingOptionals implements IPreprocessor
{
	public function new() {}

	public function buildClass(data:ClassData)
	{
		if (data.name == "Instance")
		{
			for (field in data.fields)
			{
				switch (field)
				{
					case Function(d):
						if (d.name == "WaitForChild")
							for (param in d.parameters)
								if (param.name == "timeOut")
									param.type = param.type.makeOptional();
					default:
				}
			}
		}
	}

	public function buildEnum(data:EnumData) {}
}
