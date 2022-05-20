class A {
public:
	A() {}
};

A a;
void f() {}


class Test {
	A aa;

	void fa() {}

	void test() {
		void (*fptr)();
		void (Test::*mfptr)();
		void *ptr;

		ptr = &a;
		ptr = &aa;

		fptr = f; // same as below
		fptr = &f; // same as above
		mfptr = &Test::fa;

	}
};
