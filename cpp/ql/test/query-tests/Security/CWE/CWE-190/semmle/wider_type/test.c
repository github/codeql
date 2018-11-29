
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
