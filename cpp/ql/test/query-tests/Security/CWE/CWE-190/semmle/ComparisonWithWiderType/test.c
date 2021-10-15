
void test1 (int x) {
	char c;
	for (c = 0; c < x; c++) {} //BAD
}

void test2 (int x) {
	char c;
	for (c = 0; x > c; c++) {} // BAD
}

void test3 (int x) {
	short s;
	for (s = 0; s < x; s++) {} //BAD
}

void runner() { // get range analysis to give large values to x in tests
	test1(65536);
	test2(65536);
	test3(655360);
	test7((unsigned long long)1<<48);
	test8(65536);
	test9(65536);
	test10(65536);

}

void test4 () {
	short s1;
	short s2 = 200;
	for (s1 = 0;  s1 < s2; s1++) {}
}

void test5 () {
	short s1;
	int x = 65536;
	s1 < x;
}

void test6() {
	short  s1;
	for (s1 = 0; s1 < 0x0000ffff; s1++) {}
}

void test7(long long l) {
	int i;
	for (i = 0; i < l; i++) {}
}

void test8(int x) {
	short s;
	for (s = 256; s < x; x--) {}
}


void test9(int x) {
	short s;
	for (s = 256; s < x; ) {
		x--;
	}
}

void test10(int x) {
	short s;
	for (s = 0; s < x; ) { // BAD
		do
		{
			s++;
		} while (0);
	}
}

extern const int const256;

void test11() {
	short s;
	for(s = 0; s < const256; ++s) {}
}

unsigned int get_a_uint();

void test12() {
	unsigned char c;
	unsigned int x;

	x = get_a_uint();
	for (c = 0; c < x; c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < 0xFF; c++) {} // GOOD
	x = get_a_uint();
	for (c = 0; c < 0xFF00; c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < 0xFF0000; c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < 0xFF000000; c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < (x & 0xFF); c++) {} // GOOD
	x = get_a_uint();
	for (c = 0; c < (x & 0xFF00); c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < (x & 0xFF0000); c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < (x & 0xFF000000); c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < (x >> 8); c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < (x >> 16); c++) {} // BAD
	x = get_a_uint();
	for (c = 0; c < (x >> 24); c++) {} // GOOD (assuming 32-bit ints)
	x = get_a_uint();
	for (c = 0; c < ((x & 0xFF00) >> 8); c++) {} // GOOD
	x = get_a_uint();
	for (c = 0; c < ((x & 0xFF0000) >> 16); c++) {} // GOOD
	x = get_a_uint();
	for (c = 0; c < ((x & 0xFF000000) >> 24); c++) {} // GOOD
}

int get_an_int();

void test13() {
	unsigned char uc;
	int sx, sy;
	unsigned ux, uy, sz;

	ux = get_a_uint();
	uy = get_a_uint();
	sz = ux & uy;
	for (uc = 0; uc < sz; uc++) {} // BAD

	ux = get_a_uint();
	uy = get_a_uint();
	if (ux > 128) {ux = 128;}
	sz = ux & uy;
	for (uc = 0; uc < sz; uc++) {} // GOOD

	sx = get_an_int();
	sy = get_an_int();
	sz = (unsigned)sx & (unsigned)sy;
	for (uc = 0; uc < sz; uc++) {} // BAD

	sx = get_an_int();
	sy = get_an_int();
	if (sx < 0) {sx = 0;}
	if (sx > 128) {sx = 128;}
	sz = (unsigned)sx & (unsigned)sy;
	for (uc = 0; uc < sz; uc++) {} // GOOD
}
