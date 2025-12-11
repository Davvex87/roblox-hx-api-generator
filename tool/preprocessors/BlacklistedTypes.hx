package preprocessors;

import Types;
import preprocessors.IPreprocessor;

class BlacklistedTypes implements IPreprocessor
{
	public function new() {}

	public function build(data:ParsedTypes)
	{
		var classes = new Array<ClassObj>();
		for (cls in data.classes)
		{
			if (cls.Name == "Studio")
				continue;

			classes.push(cls);
		}
		data.classes = classes;
	}
}
