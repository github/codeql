// test.c

void myFunc1();

typedef void (*voidFunPtr)();

void test()
{
	void (*funPtr1)() = &myFunc1; // GOOD
	voidFunPtr funPtr2 = &myFunc1; // GOOD
	int *intPtr = &myFunc1; // BAD (function pointer -> int pointer)
	void *voidPtr = &myFunc1; // BAD (function pointer -> void pointer)
	int i = &myFunc1; // GOOD (permitted)

	funPtr1 = funPtr1; // GOOD
	funPtr2 = funPtr1; // GOOD
	intPtr = funPtr1; // BAD (function pointer -> int pointer)
	voidPtr = funPtr1; // BAD (function pointer -> void pointer)
	i = funPtr1; // GOOD (permitted)

	funPtr1 = funPtr2; // GOOD
	funPtr2 = funPtr2; // GOOD
	intPtr = funPtr2; // BAD (function pointer -> int pointer) [NOT DETECTED]
	voidPtr = funPtr2; // BAD (function pointer -> void pointer) [NOT DETECTED]
	i = funPtr2; // GOOD (permitted)

	funPtr1 = (void (*)())funPtr1; // GOOD
	funPtr2 = (voidFunPtr)funPtr1; // GOOD
	intPtr = (int *)funPtr1; // BAD (function pointer -> int pointer)
	voidPtr = (void *)funPtr1; // BAD (function pointer -> void pointer)
	i = (int)funPtr1; // GOOD (permitted)
}
