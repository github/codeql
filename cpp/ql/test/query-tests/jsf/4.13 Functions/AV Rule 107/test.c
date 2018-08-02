
#define MY_FUNCTION_1() \
	void my_function_1();
#define MY_FUNCTION2() \
	void my_function_2()

#define MYTYPE int

void test1()
{
	void inner1(); // BAD
	extern int inner2(); // BAD
	void inner3() {}; // GOOD (this isn't a declaration, it's a GCC nested function)

	MY_FUNCTION_1(); // GOOD (in a macro)
	MY_FUNCTION_2(); // GOOD (in a macro)
	MYTYPE inner4(); // BAD (function declaration is not in the macro)
	void inner5(MYTYPE p); // BAD (function declaration is not in the macro)
}

#define STATICASSERT(cond) void staticAssert(int arg[(cond) ? (1) : (-1)])

void test2()
{
	STATICASSERT(1); // GOOD (in a macro)
}
