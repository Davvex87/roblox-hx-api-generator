package core;

import haxe.EnumTools;
import core.Expr.ValueType;

using StringTools;

class ExprTools
{
	public static inline function exclude(obj:Dynamic):Dynamic
	{
		Reflect.setField(obj, "exclude", true);
		return obj;
	}

	public static inline function isExcluded(obj:Dynamic):Bool
	{
		return Reflect.hasField(obj, "exclude");
	}

	public static inline function makeOptional(type:ValueType):ValueType
	{
		return switch (type)
		{
			case Primitive(n): n.endsWith("?") ? type : Primitive('$n?');
			case Class(n): n.endsWith("?") ? type : Class('$n?');
			case Group(n): n.endsWith("?") ? type : Group('$n?');
			case DataType(n): n.endsWith("?") ? type : DataType('$n?');
			case Enum(n): n.endsWith("?") ? type : Enum('$n?');
			case MultiReturn(v): MultiReturn(v);
		}
	}
}
