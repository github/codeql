package integerLiterals;

public class IntegerLiterals {
	int[] ints = {
		0,
		1,
		0_0,
		0___0,
		0_12, // octal
		0X012, // hex
		0xaBcDeF, // hex
		0B11, // binary
		0x80000000,
		2147483647,
		-2147483648, // special case: sign is part of the literal
		// From the JLS
		0x7fff_ffff,
		0177_7777_7777, // octal
		0b0111_1111_1111_1111_1111_1111_1111_1111, // binary
		0x8000_0000,
		0200_0000_0000,
		0b1000_0000_0000_0000_0000_0000_0000_0000,
		0xffff_ffff,
		0377_7777_7777,
		0b1111_1111_1111_1111_1111_1111_1111_1111,
		// Using Unicode escapes (which are handled during pre-processing)
		\u0030, // 0
	};

	// + and - are not part of the literal
	int[] intsWithSign = {
		+0,
		-0,
		+1,
		-1,
		+2147483647,
	};

	// The operation expression (e.g. `+`) is not a literal
	int[] numericOperations = {
		1 + 1,
		0 / 0,
	};

	Object[] nonIntLiterals = {
		"0",
		'0',
		0L,
		(int) 0L,
		0.0,
		(int) 0.0,
		Integer.MIN_VALUE,
		'a' + 'b', // result is int 195, but this is not a literal
	};

	int nonLiteral;
}
