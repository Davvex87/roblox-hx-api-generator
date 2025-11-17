package preprocessors;

import Types;

interface IPreprocessor
{
	public function build(classes:Array<ClassObj>, enums:Array<EnumObj>):Void;
}
