package preprocessors;

import Types;

class MissingOptionals implements IPreprocessor
{
	public function new() {}

	public function build(classes:Array<ClassObj>, enums:Array<EnumObj>)
	{
		for (cls in classes)
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
