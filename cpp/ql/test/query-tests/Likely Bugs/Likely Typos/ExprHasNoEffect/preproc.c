#define DEFINED

int x;

int fn1()
{
#ifdef DEFINED
	x++; // side-effect
#endif

	return 0;
}

int fn2()
{
#ifndef DEFINED
	x++; // hidden side-effect
#endif

	return 0;
}

int fn3()
{
#ifdef DEFINED
#else
	x++; // hidden side-effect
#endif

	return 0;
}

int fn4()
{
#ifdef DEFINED
#endif

	return 0;
}

/* in the following 4 cases, there is a possibility for code in the non-taken
 * branch - we can't check what that code is, because it isn't extracted, but
 * we assume there's a useful definition for the function in it */
#ifdef DEFINED
int fn5()
{
	return 0;
}
#else
#endif

#ifndef UNDEFINED
int fn6()
{
	return 0;
}
#else
#endif

#ifdef UNDEFINED
#else
int fn7()
{
	return 0;
}
#endif

#ifndef DEFINED
#else
int fn8()
{
	return 0;
}
#endif

// in this case, there is no alternate branch for code to go in
#ifdef DEFINED
int fn9()
{
	return 0;
}
#endif

void test()
{
	fn1();
	fn2();
	fn3();
	fn4(); // has no effect
	fn5();
	fn6();
	fn7();
	fn8();
	fn9(); // has no effect
}
