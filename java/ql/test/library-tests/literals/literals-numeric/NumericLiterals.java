class NumericLiterals {
	void negativeLiterals() {
		float f = -1f;
		double d = -1d;
		int i1 = -2147483647;
		int i2 = -2147483648; // CodeQL models minus as part of literal
		int i3 = -0b10000000000000000000000000000000; // binary
		int i4 = -020000000000; // octal
		int i5 = -0x80000000; // hex
		long l1 = -9223372036854775807L;
		long l2 = -9223372036854775808L; // CodeQL models minus as part of literal
		long l3 = -0b1000000000000000000000000000000000000000000000000000000000000000L; // binary
		long l4 = -01000000000000000000000L; // octal
		long l5 = -0x8000000000000000L; // hex
	}
}
