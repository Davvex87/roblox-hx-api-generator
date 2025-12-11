package preprocessors;

import Types;

interface IPreprocessor
{
	public function build(data:ParsedTypes):Void;
}

typedef ParsedTypes =
{
	var classes:Array<ClassObj>;
	var enums:Array<EnumObj>;
}
