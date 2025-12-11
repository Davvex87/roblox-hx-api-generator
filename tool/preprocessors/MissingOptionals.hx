package preprocessors;

import Types;
import preprocessors.IPreprocessor;

class MissingOptionals implements IPreprocessor
{
	public function new() {}

	public function build(data:ParsedTypes)
	{
		for (cls in data.classes)
		{
			if (cls.Name == "Instance")
			{
				for (mem in cls.Members)
				{
					if (mem.MemberType == Function && mem.Name == "WaitForChild")
					{
						for (param in mem.Parameters)
						{
							if (param.Name == "timeOut")
							{
								param.Type.Name += "?";
							}
						}
					}
				}
			}
		}
	}
}
