// test.c

void myFunc1();
void myFunc2();

typedef void (*voidFunPointer)();

void test()
{
	void (*funPtr1)() = &myFunc1;
	const void (*funPtr2)() = &myFunc1;
	const voidFunPointer funPtr3 = &myFunc1;

	funPtr1 = &myFunc2;
	funPtr2 = &myFunc2;
	//funPtr3 = &myFunc2; --- this would be a compilation error

	funPtr1(); // BAD
	funPtr2(); // BAD
	funPtr3(); // GOOD [FALSE POSITIVE]
}
