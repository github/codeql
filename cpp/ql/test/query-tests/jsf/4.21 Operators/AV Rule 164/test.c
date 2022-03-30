
void f(unsigned char uc, signed char sc, int i) {
	uc >> -1; // BAD
	uc >> 0;
	uc >> 7;
	uc >> 8; // BAD

	uc << -1; // BAD
	uc << 0;
	uc << 7;
	uc << 8; // BAD
	
	uc >>= -1; // BAD [NOT DETECTED]
	uc >>= 0; // BAD [NOT DETECTED]
	uc >>= 7;
	uc >>= 8; // BAD [NOT DETECTED]

	sc >> -1; // BAD
	sc >> 0;
	sc >> 7;
	sc >> 8; // BAD

	((unsigned char)i) >> -1; // BAD
	((unsigned char)i) >> 0;
	((unsigned char)i) >> 7;
	((unsigned char)i) >> 8; // BAD
}

