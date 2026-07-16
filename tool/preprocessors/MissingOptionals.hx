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
						{
							for (param in d.parameters)
								if (param.name == "timeOut")
									param.type = param.type.makeOptional();
						}
						else if (d.name == "FindFirstChild"
							|| d.name == "FindFirstChildOfClass"
							|| d.name == "FindFirstAncestor"
							|| d.name == "FindFirstAncestorOfClass"
							|| d.name == "FindFirstChildWhichIsA"
							|| d.name == "FindFirstAncestorWhichIsA")
						{
							for (param in d.parameters)
								if (param.name == "recursive")
									param.type = param.type.makeOptional();
						}
					default:
				}
			}
		}
	}

	public function buildEnum(data:EnumData) {}
}
