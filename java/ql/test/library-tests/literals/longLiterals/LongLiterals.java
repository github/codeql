package longLiterals;

public class LongLiterals {
	long[] longs = {
		0l,
		0L,
		1L,
		0_0L,
		0___0L,
		0_12L, // octal
		0X012L, // hex
		0xaBcDeFL, // hex
		0B11L, // binary
		9223372036854775807L,
		-9223372036854775808L, // special case: sign is part of the literal
		// From the JLS
		0x7fff_ffff_ffff_ffffL,
		07_7777_7777_7777_7777_7777L, // octal
		0b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111L, // binary
		0x8000_0000_0000_0000L,
		010_0000_0000_0000_0000_0000L,
		0b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000L,
		0xffff_ffff_ffff_ffffL,
		017_7777_7777_7777_7777_7777L,
		0b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111L,
		// Using Unicode escapes (which are handled during pre-processing)
		\u0030\u004C, // 0L
	};

	// + and - are not part of the literal
	long[] longsWithSign = {
		+0L,
		-0L,
		+1L,
		-1L,
		+9223372036854775807L,
	};

	// The operation expression (e.g. `+`) is not a literal
	long[] numericOperations = {
		1L + 1L,
		0L / 0L,
	};

	Object[] longLongLiterals = {
		"0L",
		'0',
		0,
		(long) 0,
		0.0,
		(long) 0.0,
		Long.MIN_VALUE,
	};

	long nonLiteral;
}
