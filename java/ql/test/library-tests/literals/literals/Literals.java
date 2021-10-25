package literals;

public class Literals {
	public int notAliteral;
	public void doStuff() {
		System.out.println("literal string");
		System.out.println(123);
		System.out.println(456L);
		System.out.println(123.0F);
		System.out.println(456.0D);
		System.out.println(true);
		System.out.println('x');
	}

	boolean[] booleans = {
		true,
		false
	};

	char[] chars = {
		'a',
		'\u0061', // 'a'
		'\u0000',
		'\0',
		'\n',
		'\0',
		'\\',
		'\'',
		'\123' // octal escape sequence for 'S'
	};

	double[] doubles = {
		0.0,
		0d,
		.0d,
		.0,
		-0.d,
		+0.d,
		1.234567890123456789,
		1.55555555555555555555,
		// From the JLS
		1e1,
		1.7976931348623157E308,
		-1.7976931348623157E308,
		0x1.f_ffff_ffff_ffffP+1023,
		4.9e-324,
		0x0.0_0000_0000_0001P-1022,
		0x1.0P-1074
	};

	float[] floats = {
		0.0f,
		0f,
		.0f,
		-0.f,
		+0.f,
		1_0_0.0f,
		1.234567890123456789f,
		1.55555555555555555555f,
		// From the JLS
		1e1f,
		3.4028235e38f,
		-3.4028235e38f,
		0x1.fffffeP+127f,
		1.4e-45f,
		0x0.000002P-126f,
		0x1.0P-149f
	};

	int[] ints = {
		0,
		0_0,
		0___0,
		0_12, // octal
		0X012, // hex
		0xaBcDeF, // hex
		0B11, // binary
		0x80000000,
		2147483647,
		-2147483648,
		// From the JLS
		0x7fff_ffff,
		0177_7777_7777, // octal
		0b0111_1111_1111_1111_1111_1111_1111_1111, // binary
		0x8000_0000,
		0200_0000_0000,
		0b1000_0000_0000_0000_0000_0000_0000_0000,
		0xffff_ffff,
		0377_7777_7777,
		0b1111_1111_1111_1111_1111_1111_1111_1111
	};

	long[] longs = {
		0l,
		0L,
		0_0L,
		0___0L,
		0_12L, // octal
		0X012L, // hex
		0xaBcDeFL, // hex
		0B11L, // binary
		9223372036854775807L,
		-9223372036854775808L,
		// From the JLS
		0x7fff_ffff_ffff_ffffL,
		07_7777_7777_7777_7777_7777L, // octal
		0b0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111L, // binary
		0x8000_0000_0000_0000L,
		010_0000_0000_0000_0000_0000L,
		0b1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000L,
		0xffff_ffff_ffff_ffffL,
		017_7777_7777_7777_7777_7777L,
		0b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111L
	};

	String[] strings = {
		"hello" + "world", // two separate literals
		"hello,\tworld",
		"hello,\u0009world",
		"\u0061", // 'a'
		"\0",
		"\0000",
		"\"",
		"\'",
		"\n",
		"\\",
		"test \123", // octal escape sequence for 'S'
		"\1234", // octal escape followed by '4'
		"\u0061567", // escape sequence for 'a' followed by "567"
		"\u1234567", // '\u1234' followed by "567"
		"\uaBcDeF\u0aB1", // '\uABCD' followed by "eF" followed by '\u0AB1'
		"\uD800\uDC00", // surrogate pair
		// Unpaired surrogates
		"\uD800",
		"\uDC00",
		"hello\uD800hello\uDC00world"
	};
}
