
class MyClass
{
public:
	int a, b;
};

MyClass *test1()
{
	MyClass mc;

	return &mc; // BAD [NOT DETECTED]
}

MyClass *test2()
{
	MyClass mc;
	MyClass *ptr = &mc;

	return ptr; // BAD [NOT DETECTED]
}

MyClass *test3()
{
	MyClass mc;
	MyClass &ref = mc;

	return &ref; // BAD [NOT DETECTED]
}

int *test4()
{
	MyClass mc;

	return &(mc.a); // BAD [NOT DETECTED]
}

MyClass test6()
{
	MyClass mc;

	return mc; // GOOD
}

MyClass *test7()
{
	MyClass *mc = new MyClass;

	return mc; // GOOD
}

MyClass test8()
{
	return MyClass(); // GOOD
}

int test9()
{
	MyClass mc;

	return mc.a; // GOOD
}

MyClass *test10()
{
	MyClass *ptr;

	{
		MyClass mc;
		ptr = &mc;
	}

	return ptr; // BAD [NOT DETECTED]
}

MyClass *test11(MyClass *param)
{
	return param; // GOOD
}

MyClass *test12()
{
	static MyClass mc;
	MyClass &ref = mc;

	return &ref; // GOOD
}

char *testArray1()
{
	char arr[256];

	return arr; // BAD
}

char *testArray2()
{
	char arr[256];

	return &(arr[10]); // BAD [NOT DETECTED]
}

char testArray3()
{
	char arr[256];

	return arr[10]; // GOOD
}

char *testArray4()
{
	char arr[256];
	char *ptr;

	ptr = arr + 1;
	ptr++;

	return ptr; // BAD [NOT DETECTED]
}

char *testArray5()
{
	static char arr[256];

	return arr; // GOOD
}
