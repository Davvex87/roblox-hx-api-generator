package generator;

import core.Expr;
import preprocessors.IPreprocessor;
import core.RobloxTypes;

using core.ExprTools;
using StringTools;
using hx.strings.Strings;

class Generator
{
	var preprocessors:Array<IPreprocessor>;

	public function new(preprocessors:Array<IPreprocessor>)
	{
		this.preprocessors = preprocessors;
	}

	public function generateClass(data:ClassData):Null<String>
	{
		for (preprocessor in preprocessors)
			preprocessor.buildClass(data);

		if (data.isExcluded())
			return null;

		final isService = data.tags.contains(Service);

		var gPackage:String = 'rblx.${isService ? "services" : "instances"}';
		var gImports:Array<String> = ["rblx.*", "rblx.instances.*", "rblx.services.*", "rblx.enums.*"];
		var gClassMetas:Array<String> = [isService ? '@:rblxService' : '@:rblxObject'];
		var gClassHeader:String =
			{
				var h = 'extern class ${data.name}';
				if (data.superClass != null)
					h += ' extends ${data.superClass}';
				h;
			};

		var gMembers:Array<String> = data.fields.map(generateField).filter(f -> f != null);
		var gMultiReturns:Array<String> = generateMultiReturns(data);

		var output:StringBuf = new StringBuf();

		output.add('package ${gPackage};\n\n');
		output.add(gImports.map(f -> 'import ${f};').join('\n') + '\n\n');
		output.add(gClassMetas.join('\n') + '\n');
		output.add(gClassHeader + '\n');
		output.add('{\n');
		output.add(gMembers.map(f -> '\t' + f.replace('\n', '\n\t')).join('\n\n'));
		output.add('\n}');
		if (gMultiReturns.length > 0)
		{
			output.add('\n\n');
			output.add(gMultiReturns.join('\n\n'));
		}

		return output.toString();
	}

	function generateField(field:FieldKind):Null<String>
	{
		if (field.isExcluded())
			return null;

		var baseField = extractBaseField(field);
		var genString:String;

		final fieldName = parseName(baseField.name);

		final isReadonly = baseField.tags.contains(ReadOnly);

		switch (field)
		{
			case Property(d):
				genString = '${isReadonly ? "final" : "var"} $fieldName:${makeType(d.valueType)};';

			case Function(d):
				genString = 'function $fieldName(';
				var params = d.parameters.filter(p -> !p.isExcluded()).map(parseParameter);
				genString += params.join(', ');
				genString += '):${makeType(d.returnType).replace("::fieldName::", baseField.name)};';

			case Event(d):
				genString = 'var $fieldName:RBXScriptSignal<(';
				var params = d.parameters.filter(p -> !p.isExcluded()).map(parseParameter);
				genString += params.join(', ');
				genString += ') -> Void>;';

			case Callback(d):
				genString = 'dynamic function $fieldName(never, set):(';
				var params = d.parameters.filter(p -> !p.isExcluded()).map(parseParameter);
				genString += params.join(', ');
				genString += ')->${makeType(d.returnType)};';
		}

		var metas = generateSharedFieldMetas(baseField);

		return metas.join('\n') + '\n' + genString;
	}

	function makeType(valueType:ValueType):String
	{
		var typeOut = switch (valueType)
		{
			case Primitive(n): RobloxTypes.makePrimitiveType(n);
			case Group(n): RobloxTypes.makeGroupType(n);
			case DataType(n): RobloxTypes.makeDataType(n);
			case Class(n): RobloxTypes.extract(n);
			case Enum(n): RobloxTypes.extract(n);
			case MultiReturn(_): {type: '::fieldName::Result', optional: false};
		}

		if (typeOut.optional)
			return 'Null<${typeOut.type}>';

		return typeOut.type;
	}

	function getType(valueType:ValueType):TypeOut
	{
		return switch (valueType)
		{
			case Primitive(n): RobloxTypes.makePrimitiveType(n);
			case Group(n): RobloxTypes.makeGroupType(n);
			case DataType(n): RobloxTypes.makeDataType(n);
			case Class(n): RobloxTypes.extract(n);
			case Enum(n): RobloxTypes.extract(n);
			case MultiReturn(_): {type: '::fieldName::Result', optional: false};
		}
	}

	function extractBaseField(field:FieldKind):BaseField
	{
		return switch (field)
		{
			case Property(d): d;
			case Function(d): d;
			case Event(d): d;
			case Callback(d): d;
		}
	}

	function generateSharedFieldMetas(field:BaseField):Array<String>
	{
		var metas:Array<String> = ['@:native("${field.name}")'];

		if (field.tags.contains(Deprecated))
			metas.push('@:deprecated');

		return metas;
	}

	function generateMultiReturns(data:ClassData):Array<String>
	{
		var multiReturns:Array<String> = [];

		for (field in data.fields)
		{
			if (field.isExcluded())
				continue;

			var baseField = extractBaseField(field);

			switch (field)
			{
				case Function(d):
					switch (d.returnType)
					{
						case MultiReturn(v):
							var gRet = '@:multiReturn extern class ${baseField.name}Result\n{\n\t';

							var returnNames = getReturnNames(baseField, data);
							var retFields = [for (i in 0...v.length) 'var ${returnNames[i]}:${makeType(v[i])};'];

							gRet += retFields.join('\n\t');
							gRet += '\n}';

							multiReturns.push(gRet);
						default:
					}
				default:
			}
		}

		return multiReturns;
	}

	function getReturnNames(field:BaseField, data:ClassData):Array<String>
	{
		switch (data.name)
		{
			case "Humanoid":
				switch (field.name)
				{
					case "ComputeR15BodyBoundingBox":
						return ["cFrame", "size"];
				}

			case "Model":
				switch (field.name)
				{
					case "GetBoundingBox":
						return ["cFrame", "size"];
				}

			case "TweenService":
				switch (field.name)
				{
					case "SmoothDamp":
						return ["newValue", "newVelocity"];
				}
		}
		return [];
	}

	public function generateEnum(data:EnumData):Null<String>
	{
		for (preprocessor in preprocessors)
			preprocessor.buildEnum(data);

		if (data.isExcluded())
			return null;

		var output:StringBuf = new StringBuf();
		output.add('package rblx.enums;\n\n');
		output.add('import rblx.*;\n\n');
		output.add('@:native("Enum.${data.name}")\n');
		output.add('@:rblxEnum\n');
		output.add('extern enum abstract ${data.name}(EnumItem<${data.name}>)\n{\n');

		var enumItems:Array<String> = [];

		for (item in data.items)
		{
			enumItems.push('\tvar ${parseName(item.name, true)}:EnumItem<${data.name}>;');
		}

		output.add(enumItems.join('\n'));
		output.add('\n}');

		return output.toString();
	}

	function parseName(str:String, noFormat:Bool = false):String
	{
		var out = str.toLowerCamel();
		if (out == "function" || out == "default" || out == "var" || out == "extern" || out == "class" || out == "enum" || out == "switch"
			|| out == "import" || out == "using" || out == "final" || out == "public" || out == "private" || out == "static" || out == "case"
			|| out == "for" || out == "return" || out == "if" || out == "else" || out == "in" || out == "to" || out == "from" || out == "package"
			|| out == "typedef" || out == "implements" || out == "interface" || out == "operator" || out == "override" || out == "abstract"
			|| out == "break" || out == "continue" || out == "true" || out == "false" || out == "null" || out == "new" || out == "is")
			return '${noFormat ? str : out}_';
		return noFormat ? str : out;
	}

	function parseParameter(param:Parameter):String
	{
		var type = getType(param.type);
		var gParam = '${type.optional ? "?" : ""}${parseName(param.name)}:${type.type}';
		// TODO: Default value
		return gParam;
	}
}
