int test1(int x) {
	return x % 2 == 1; // BAD
}

int test2(unsigned int x) {
	return x % 2 == 1; // GOOD: x is unsigned and thus non-negative.
}

int test3(short x) {
	return x % 2 == 1; // BAD
}

int test4(unsigned short x) {
	return x % 2 == 1; // GOOD: x is unsigned and thus non-negative.
}
