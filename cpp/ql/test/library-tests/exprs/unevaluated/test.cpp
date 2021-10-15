#include "typeinfo.h"

int test1() {
	int x;
	return sizeof(x); // unevaluated
}

int test2() {
	int x;
	return sizeof(x + 1); // unevaluated
}

class MyClass {
public:
	int field;
};

void test3() {
	MyClass my_class;
	int x;
	decltype(my_class.field) y = x; // unevaluated
}

void test4() {
	int x;
	noexcept(x); // unevaluated
}

void test5() {
	int x;
	typeid(x); // unevaluated
}


class NoVirtual {
public:
	int x;
};

void test6() {
	NoVirtual x;
	typeid(*&x); // unevaluated
}

class Virtual {
public:
	int x;
	virtual int GetX();
};

void test7() {
	Virtual x;
	typeid(x); // evaluated
}

void test8() {
	typeid(4); // unevaluated
}

Virtual getAVirtual();

void test9() {
	typeid(getAVirtual()); // unevaluated
}
