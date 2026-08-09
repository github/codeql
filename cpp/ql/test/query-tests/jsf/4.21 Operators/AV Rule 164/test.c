
void f(unsigned char uc, signed char sc, int i) {
	uc >> -1; // $ Alert // BAD
	uc >> 0;
	uc >> 7;
	uc >> 8; // $ Alert // BAD

	uc << -1; // $ Alert // BAD
	uc << 0;
	uc << 7;
	uc << 8; // $ Alert // BAD

	uc >>= -1; // $ MISSING: Alert // BAD [NOT DETECTED]
	uc >>= 0; // $ MISSING: Alert // BAD [NOT DETECTED]
	uc >>= 7;
	uc >>= 8; // $ MISSING: Alert // BAD [NOT DETECTED]

	sc >> -1; // $ Alert // BAD
	sc >> 0;
	sc >> 7;
	sc >> 8; // $ Alert // BAD

	((unsigned char)i) >> -1; // $ Alert // BAD
	((unsigned char)i) >> 0;
	((unsigned char)i) >> 7;
	((unsigned char)i) >> 8; // $ Alert // BAD
}
