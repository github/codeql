typedef long size_t;

void test1() {
	int x = x; // BAD
}

void test2() {
	int x = x = 2; // BAD
}

void test3() {
	int x = 2; // GOOD
}

void test4() {
	void* x = (void *)&x; // GOOD
}

void test5() {
	size_t x = sizeof(x); // GOOD
}

typedef void *voidptr;

voidptr address_of(voidptr &var) {
	// return a void pointer pointing to the supplied void pointer
	return &var;
}

void test6() {
	voidptr x = address_of(x); // GOOD (implicit conversion to reference)
}


struct MyString {
	int *data; // points to the string
	int array[1]; // for convenience
};

void test7() {
	MyString ms = {ms.array, {0}}; // GOOD (implicit conversion to pointer)
}

#define uninitialized(x) x

void test8() {
	int x = uninitialized(x); // GOOD (rval is a macro)
}

#define uninitialized2(x) x = x

void test9() {
	int uninitialized2(x); // GOOD (initializer is a macro)
}

void test10() {
	int x = x + 1; // BAD: x is evaluated on the right hand side
}

void test11() {
	int x = uninitialized(x) + 1; // BAD: x is evaluated on the right hand side
}

#define self_initialize(t, x) t x = x

void test12() {
	self_initialize(int, x); // GOOD (statement is from a macro)
}
