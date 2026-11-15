package rblx;

/**
	A buffer is an object that represents a fixed-size mutable block of memory. The buffer library provides functions for creation and manipulation of buffer objects, providing all its functions inside the global buffer variable.

	Buffer is intended to be used a low-level binary data storage structure, replacing the uses of string.pack() and string.unpack(). Use cases include reading and writing existing binary formats, working with data in a more compact form, serialization to custom binary formats, and general work with native memory types like fixed-length integers and floats.

	When passed through Roblox APIs, including sending a buffer through custom events, the identity of the buffer object is not preserved and the target will receive a copy. Similar to other limitations, the same buffer object cannot be used from multiple Actor scripts (Parallel Luau).

	Many of the functions accept an offset in bytes from the start of the buffer. Offset of 0 from the start of the buffer memory block accesses the first byte. All offsets, counts and sizes should be non-negative integer numbers. If the bytes that are accessed by any read or write operation are outside the buffer memory, an error is thrown.

	The read and write methods that work with integers and floats use little-endian encoding.
**/
@:native("buffer")
extern class Buffer
{
	/**
		Creates a buffer of the requested size with all bytes initialized to 0. Size limit is 1 GiB, or 1,073,741,824 bytes. Keep in mind that larger buffers might fail to allocate if device is running low on memory.
	**/
	static function create(size:Int):Buffer;

	/**
		Creates a buffer initialized to the contents of the string. The size of the buffer equals the length of the string.
	**/
	static function fromstring(str:String):Buffer;

	/**
		Returns the buffer data as a string.
	**/
	static function tostring(b:Buffer):String;

	/**
		Returns the size of the buffer in bytes.
	**/
	static function len(b:Buffer):Int;

	/**
		Reads a range of bits into an unsigned integer from the buffer based on a specific bitCount integer from 0 to 32, inclusive. For example:

		- ``buffer.readbits(b, 0, 8)`` is equivalent to buffer.readu8(b, 0).
		- ``buffer.readbits(b, 0, 16)`` is equivalent to buffer.readu16(b, 0).
		- ``buffer.readbits(b, 0, 32)`` is equivalent to buffer.readu32(b, 0).
		- ``buffer.readbits(b, 0, 24)`` reads 24 bits from the buffer.

		Note that 0 bit width is supported only to not error in generalized cases where bit count is dynamic, and reading 0 bits returns 0. Also note that, since the max size of the buffer is 1 GB, bitOffset cannot be handled as a 32‑bit integer number like byte offset in other buffer functions.
	**/
	static function readbits(b:Buffer, bitOffset:Int, bitCount:Int):Int;

	/**
		Reads an 8-bit signed integer from the buffer.
	**/
	static function readi8(b:Buffer, offset:Int):Int;

	/**
		Reads an 8-bit unsigned integer from the buffer.
	**/
	static function readu8(b:Buffer, offset:Int):UInt;

	/**
		Reads a 16-bit signed integer from the buffer.
	**/
	static function readi16(b:Buffer, offset:Int):Int;

	/**
		Reads a 16-bit unsigned integer from the buffer.
	**/
	static function readu16(b:Buffer, offset:Int):UInt;

	/**
		Reads a 32-bit signed integer from the buffer.
	**/
	static function readi32(b:Buffer, offset:Int):Int;

	/**
		Reads a 32-bit unsigned integer from the buffer.
	**/
	static function readu32(b:Buffer, offset:Int):UInt;

	/**
		Reads a 32-bit floating-point value from the buffer.
	**/
	static function readf32(b:Buffer, offset:Int):Float;

	/**
		Reads two 32-bit floating-point values from the buffer into a vector.
	**/
	static function readvectorf32x2(b:Buffer, offset:Int):Vector3;

	/**
		Reads three 32-bit floating-point values from the buffer into a vector.
	**/
	static function readvectorf32x3(b:Buffer, offset:Int):Vector3;

	/**
		Reads a 64-bit floating-point value from the buffer.
	**/
	static function readf64(b:Buffer, offset:Int):Float;

	/**
		Writes data to the buffer based on a specific bitCount integer from 0 to 32, inclusive.
	**/
	static function writebits(b:Buffer, bitOffset:Int, bitCount:Int, value:Int):Void;

	/**
		Writes an 8-bit signed integer to the buffer.
	**/
	static function writei8(b:Buffer, offset:Int, value:Int):Void;

	/**
		Writes an 8-bit unsigned integer to the buffer.
	**/
	static function writeu8(b:Buffer, offset:Int, value:UInt):Void;

	/**
		Writes a 16-bit signed integer to the buffer.
	**/
	static function writei16(b:Buffer, offset:Int, value:Int):Void;

	/**
		Writes a 16-bit unsigned integer to the buffer.
	**/
	static function writeu16(b:Buffer, offset:Int, value:UInt):Void;

	/**
		Writes a 32-bit signed integer to the buffer.
	**/
	static function writei32(b:Buffer, offset:Int, value:Int):Void;

	/**
		Writes a 32-bit unsigned integer to the buffer.
	**/
	static function writeu32(b:Buffer, offset:Int, value:UInt):Void;

	/**
		Writes a 32-bit floating-point value to the buffer.
	**/
	static function writef32(b:Buffer, offset:Int, value:Float):Void;

	/**
		Writes two vector components as 32-bit floating-point values to the buffer.
	**/
	static function writevectorf32x2(b:Buffer, offset:Int, value:Vector3):Void;

	/**
		Writes three vector components as 32-bit floating-point values to the buffer.
	**/
	static function writevectorf32x3(b:Buffer, offset:Int, value:Vector3):Void;

	/**
		Writes a 64-bit floating-point value to the buffer.
	**/
	static function writef64(b:Buffer, offset:Int, value:Float):Void;

	/**
		Reads a string from the buffer.
	**/
	static function readstring(b:Buffer, offset:Int, count:Int):String;

	/**
		Writes a string to the buffer.
	**/
	static function writestring(b:Buffer, offset:Int, value:String, ?count:Int):Void;

	/**
		Copies count bytes from source starting at offset sourceOffset into the target at targetOffset.

		It's possible for source and target to be the same. Copying an overlapping region inside the same buffer acts as if the source region is copied into a temporary buffer and then that buffer is copied over to the target.
	**/
	static function copy(target:Buffer, targetOffset:Int, source:Buffer, ?sourceOffset:Int, ?count:Int):Void;

	/**
		Sets a region of the buffer memory to some 8-bit unsigned integer value.
	**/
	static function fill(b:Buffer, offset:Int, value:Int, ?count:Int):Void;
}
