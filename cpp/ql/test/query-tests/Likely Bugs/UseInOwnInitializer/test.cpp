typedef long size_t;

void test1() {
	int x = x;
}

void test2() {
	int x = x = 2;
}

void test3() {
	int x = 2;
}

void test4() {
	void* x = (void *)&x;
}

void test5() {
	size_t x = sizeof(x);
}

typedef void *voidptr;

voidptr address_of(voidptr &var) {
	// return a void pointer pointing to the supplied void pointer
	return &var;
}

void test6() {
	voidptr x = address_of(x); // initialize to it's own address
}


struct MyString {
	int *data; // points to the string
	int array[1]; // for convenience
};

void test7() {
	MyString ms = {ms.array, {0}}; // initialize to ""
}

#define uninitialized(x) x

void test8() {
	int x = uninitialized(x);
}

#define uninitialized2(x) x = x

void test9() {
	int uninitialized2(x);
}

void test10() {
	int x = x + 1;
}

void test11() {
	int x = uninitialized(x) + 1;
}
