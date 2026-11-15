package core;

import hx.strings.collection.StringMap;
import haxe.extern.EitherType;
import core.JsonInput;
import haxe.EnumTools;
import core.Expr;
import core.DocsParser.ParsedMemberDocData;

using macros.StructureCombiner;

class ExprParser
{
	public static function parseString(str:String):ParserResult
	{
		var jsonData:JsonInput = haxe.Json.parse(str);
		return parseExpr(jsonData);
	}

	public static function parseExpr(data:JsonInput):ParserResult
	{
		var result = {
			classes: [],
			enums: []
		}

		var classMap:StringMap<ClassData> = new StringMap<ClassData>();

		for (classData in data.Classes)
		{
			var parsedData = parseClassData(classData);
			classMap.set(parsedData.name, parsedData);
			result.classes.push(parsedData);
		}

		for (classData in data.Classes)
		{
			var superClassName = parseSuperClass(classData.Superclass);
			if (superClassName != null)
			{
				var superClass = classMap.get(superClassName);
				if (superClass != null)
				{
					var parsedClass = classMap.get(classData.Name);
					if (parsedClass != null)
						parsedClass.superClass = superClass;
				}
			}
		}

		for (enumData in data.Enums)
			result.enums.push(parseEnumData(enumData));

		return result;
	}

	static function parseClassData(classData:RblxClassData):ClassData
	{
		DocsParser.setClassFocus(classData.Name);
		var fields:Array<FieldKind> = classData.Members.map(parseClassField);
		var classDocs = DocsParser.getClassFocusData();

		return {
			name: classData.Name,
			superClass: null,
			tags: classData.Tags != null ? classData.Tags.map(parseTag) : [],
			memoryCategory: parseMemoryCategory(classData.MemoryCategory),
			fields: fields,
			documentation: classDocs?.summary,
			deprecationMessage: classDocs?.deprecationMessage
		};
	}

	static function parseClassField(member:RblxMember):FieldKind
	{
		var baseField = getFieldBase(member);
		var docs = DocsParser.getMemberDocs(member.MemberType, member.Name);
		var parseParam = (p:RblxParameter) -> parseParameter(p, docs);

		switch (member.MemberType)
		{
			case "Property":
				return Property(baseField.combine({
					category: parseCategory(member.Category),
					valueType: parseValueType(member.ValueType)
				}));
			case "Function":
				return Function(baseField.combine({
					returnType: parseValueType(member.ReturnType),
					parameters: member.Parameters?.map(parseParam) ?? [],
					returnDocumentation: joinReturnDocs(docs)
				}));
			case "Event":
				return Event(baseField.combine({
					parameters: member.Parameters?.map(parseParam) ?? []
				}));
			case "Callback":
				return Callback(baseField.combine({
					returnType: parseValueType(member.ReturnType),
					parameters: member.Parameters?.map(parseParam) ?? [],
					returnDocumentation: joinReturnDocs(docs)
				}));
		}

		throw 'Unknown class member of type ${member.MemberType}';
	}

	static function joinReturnDocs(docs:Null<ParsedMemberDocData>):Null<String>
	{
		if (docs == null || docs.returns.length == 0)
			return null;
		return docs.returns.join("\n");
	}

	static function getFieldBase(member:RblxMember):BaseField
	{
		var docs = DocsParser.getMemberDocs(member.MemberType, member.Name);
		return {
			capabilities: parseCapabilities(member.Capabilities),
			name: member.Name,
			security: parseMemberSecurity(member.Security),
			tags: member.Tags != null ? member.Tags.map(parseTag) : [],
			threadSafety: parseThreadSafety(member.ThreadSafety),
			documentation: docs?.summary,
			deprecationMessage: docs?.deprecationMessage
		};
	}

	static function parseCapabilities(capabilities:EitherType<Array<String>, RblxCapability>):Capabilities
	{
		if (capabilities == null)
			return {read: [], write: []};

		if (capabilities is Array)
		{
			var capArray:Array<Capability> = cast(capabilities : Array<String>).map(parseCapability);
			return {read: capArray, write: capArray};
		}
		else
		{
			var capObj:RblxCapability = cast capabilities;
			return {read: capObj.Read != null ? capObj.Read.map(parseCapability) : [], write: capObj.Write != null ? capObj.Write.map(parseCapability) : []};
		}
	}

	static function parseCapability(capabilityName:String):Capability
	{
		var enumObj = EnumTools.createByName(Capability, capabilityName);
		if (enumObj == null)
			throw 'Capability $capabilityName has not been registered';

		return enumObj;
	}

	static function parseMemberSecurity(security:EitherType<RblxSecurity, String>):MemberSecurity
	{
		if (security is String)
		{
			var secStr:String = cast security;
			var secEnum = EnumTools.createByName(Security, secStr);
			if (secEnum == null)
				throw 'Security $secStr has not been registered';

			return {read: secEnum, write: secEnum};
		}
		else
		{
			var secObj:RblxSecurity = cast security;
			return {read: parseSecurity(secObj.Read), write: parseSecurity(secObj.Write)};
		}
	}

	static function parseSecurity(securityName:String):Security
	{
		var enumObj = EnumTools.createByName(Security, securityName);
		if (enumObj == null)
			throw 'Security $securityName has not been registered';

		return enumObj;
	}

	static function parseThreadSafety(threadSafetyName:String):ThreadSafety
	{
		var enumObj = EnumTools.createByName(ThreadSafety, threadSafetyName);
		if (enumObj == null)
			throw 'ThreadSafety $threadSafetyName has not been registered';

		return enumObj;
	}

	static function parseSuperClass(?superClass:String):Null<String>
	{
		if (superClass == null || superClass == "<<<ROOT>>>")
			return null;

		return superClass;
	}

	static function parseTag(tagName:String):Tag
	{
		var enumObj = EnumTools.createByName(Tag, tagName);
		if (enumObj == null)
			throw 'Tag $tagName has not been registered';

		return enumObj;
	}

	static function parseMemoryCategory(categoryName:String):MemoryCategory
	{
		var enumObj = EnumTools.createByName(MemoryCategory, categoryName);
		if (enumObj == null)
			throw 'MemoryCategory $categoryName has not been registered';

		return enumObj;
	}

	static inline function parseCategory(categoryName:String):String
	{
		return categoryName;
	}

	static function parseParameter(param:RblxParameter, ?docs:ParsedMemberDocData):Parameter
	{
		return {
			name: param.Name,
			type: parseValueType(param.Type),
			defaultValue: param.Default,
			documentation: docs?.parameters.get(param.Name)
		};
	}

	static function parseValueType(valueType:RblxReturnType):ValueType
	{
		if (valueType == null)
			return Primitive("Void");

		if (valueType is Array)
		{
			var typeArray:Array<RblxType> = cast valueType;
			if (typeArray.length == 1)
				return parseValueType(typeArray[0]);
			else
				return MultiReturn(typeArray.map(parseValueType));
		}
		else
		{
			var typeObj:RblxType = cast valueType;
			switch (typeObj.Category)
			{
				case "Primitive":
					return Primitive(typeObj.Name);
				case "Class":
					return Class(typeObj.Name);
				case "Group":
					return Group(typeObj.Name);
				case "DataType":
					return DataType(typeObj.Name);
				case "Enum":
					return Enum(typeObj.Name);
			}

			throw 'Unknown value type category ${typeObj.Category}';
		}
	}

	static function parseEnumData(enumData:RblxEnumData):EnumData
	{
		var enumDocs = DocsParser.getEnumDocs(enumData.Name);
		var items:Array<EnumItem> = enumData.Items.map(item -> parseEnumItem(item, enumDocs?.items.get(item.Name)));

		return {
			name: enumData.Name,
			tags: enumData.Tags?.map(parseTag) ?? [],
			items: items,
			documentation: enumDocs?.summary,
			deprecationMessage: enumDocs?.deprecationMessage
		};
	}

	static function parseEnumItem(enumItem:RblxEnumItem, ?docs:ParsedMemberDocData):EnumItem
	{
		return {
			name: enumItem.Name,
			value: enumItem.Value,
			deprecated: enumItem.Tags?.contains("Deprecated") ?? false,
			documentation: docs?.summary,
			deprecationMessage: docs?.deprecationMessage
		};
	}
}

typedef ParserResult =
{
	var classes:Array<ClassData>;
	var enums:Array<EnumData>;
}
