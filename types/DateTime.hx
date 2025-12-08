package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("DateTime")
extern abstract DateTime(DateTimeData) {}

@:native("DateTime")
private extern class DateTimeData
{
	/**
	 * Returns a DateTime representing the current moment in time.
	 */
	static function now():DateTime;

	/**
	 * Returns a DateTime representing the given Unix timestamp.
	 */
	static function fromUnixTimestamp(unixTimestamp:Float):DateTime;

	/**
	 * Returns a DateTime representing the given Unix timestamp in milliseconds.
	 */
	static function fromUnixTimestampMillis(unixTimestampMillis:Float):DateTime;

	/**
	 * Returns a new DateTime using the given units from a UTC time.
	 */
	static function fromUniversalTime(year:Float, month:Float, day:Float, hour:Float, minute:Float, second:Float, millisecond:Float):DateTime;

	/**
	 * Returns a new DateTime using the given units from a local time.
	 */
	static function fromLocalTime(year:Float, month:Float, day:Float, hour:Float, minute:Float, second:Float, millisecond:Float):DateTime;

	/**
	 * Returns a DateTime from an ISO 8601 date-time string (in UTC).
	 */
	static function fromIsoDate(isoDate:String):DateTime;

	/**
	 * The number of seconds between January 1st, 1970 at 00:00 UTC (the Unix epoch).
	 */
	@:native("UnixTimestamp")
	var unixTimestamp:Float;

	/**
	 * The number of milliseconds between January 1st, 1970 at 00:00 UTC (the Unix epoch).
	 */
	@:native("UnixTimestampMillis")
	var unixTimestampMillis:Float;

	/**
	 * Returns the components of the DateTime in UTC.
	 */
	@:native("ToUniversalTime")
	function toUniversalTime():Dictionary;

	/**
	 * Returns the components of the DateTime in local time.
	 */
	@:native("ToLocalTime")
	function toLocalTime():Dictionary;

	/**
	 * Returns the DateTime as an ISO 8601 date-time string.
	 */
	@:native("ToIsoDate")
	function toIsoDate():String;

	/**
	 * Returns the DateTime's value in UTC formatted into a string.
	 */
	@:native("FormatUniversalTime")
	function formatUniversalTime(format:String, locale:String):String;

	/**
	 * Returns the DateTime object's value in local time formatted into a string.
	 */
	@:native("FormatLocalTime")
	function formatLocalTime(format:String, locale:String):String;
}
