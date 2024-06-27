// Semmle test cases for rule CWE-416.

// library types, functions etc
#define NULL (0)
typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);

void useExternal(...);

void use_if_nonzero(char* data)
{
	if (data)
		useExternal(data);
}

void use(char* data) {
	useExternal(*data);
}

[[noreturn]]
void noReturn();

void myMalloc(char** data)
{
	*data = (char *)malloc(100*sizeof(char));
}

void myMalloc2(char* & data)
{
	data = (char*) malloc(100*sizeof(char));
}

void test1()
{
	char* data;
	data = (char *)malloc(100*sizeof(char));
	use_if_nonzero(data); // GOOD
	free(data);
	use_if_nonzero(data); // BAD [NOT DETECTED]
	use(data); // BAD
}

void test2()
{
	char* data;
	data = (char *)malloc(100*sizeof(char));
	free(data);
	myMalloc(&data);
	use_if_nonzero(data); // GOOD
	use(data); // GOOD
	free(data);
	myMalloc2(data);
	use_if_nonzero(data); // GOOD
	use(data); // GOOD
}

void test3()
{
	char* data;
	data = (char *)malloc(100*sizeof(char));
	free(data);
	data = NULL;
	if (data)
	{
		use_if_nonzero(data); // GOOD
		use(data); // GOOD
	}
}

void test4()
{
	char* data;
	data = (char *)malloc(100*sizeof(char));
	free(data);
	if (data)
	{
		use_if_nonzero(data); // BAD [NOT DETECTED]
		use(data); // BAD
	}
}

char* returnsFreedData(int i)
{
	char* data;
	data = (char *)malloc(100*sizeof(char));
	if (i > 0)
	{
		free(data);
	}
	return data;
}

void test5()
{
	char* data = returnsFreedData(1);
	use_if_nonzero(data); // BAD [NOT DETECTED]
	use(data); // BAD [NOT DETECTED]
}

void test6()
{
	char *data, *data2;
	data = (char *)malloc(100*sizeof(char));
	data2 = data;
	free(data);
	use_if_nonzero(data2); // BAD [NOT DETECTED]
	use(data); // BAD
}

void test7()
{
	char *data, *data2;
	data = (char *)malloc(100*sizeof(char));
	data2 = data;
	free(data);
	data2 = NULL;
	use_if_nonzero(data); // BAD [NOT DETECTED]
	use(data); // BAD
}

void test8()
{
	char *data, *data2;
	data2 = (char *)malloc(100*sizeof(char));
	data = data2;
	free(data);
	data2 = NULL;
	use_if_nonzero(data); // BAD [NOT DETECTED]
	use(data); // BAD
}

void noReturnWrapper() { noReturn(); }

void test9()
{
	char *data, *data2;
	free(data);
	noReturnWrapper();
	use_if_nonzero(data); // GOOD
	use(data); // GOOD
}

void test10()
{
	for (char *data; true; data = NULL)
	{
		use_if_nonzero(data); // GOOD
		use(data); // GOOD
		free(data);
	}
}

class myClass
{
public:
	myClass() { }

	void myMethod() { }
};

void test11() {
	myClass* c = new myClass();
	delete(c);
	c->myMethod(); // BAD
	(*c).myMethod(); // BAD
}

template<class T> T test()
{
	T* x;
	use(x); // GOOD
	delete x;
	use_if_nonzero(x); // BAD [NOT DETECTED]
	use(x); // BAD [NOT DETECTED]
}

void test12(int count)
{
	char* data = NULL;
	free(data);
	for (int i = 0; i < count; i++)
	{
		data = NULL;
	}
	use(data); // BAD
}

void test13()
{
	char* data = NULL;
	free(data);
	for (int i = 0; i < 2; i++)
	{
		data = NULL;
	}
	use(data); // GOOD [FALSE POSITIVE]
}

void test14()
{
	char* data = NULL;
	free(data);
	for (int i = 0; i < 2; i++)
	{
		data = NULL;
		free(data);
	}
	use(data); // BAD
}

template<class T> T test15()
{
	T* x;
	use(x); // GOOD
	delete x;
	use(x); // BAD [NOT DETECTED]
}
void test15runner(void)
{
  test15<char>();
}

void regression_test_for_static_var_handling()
{
	static char *data;
	data = (char *)malloc(100*sizeof(char));
	free(data);
	data = (char *)malloc(100*sizeof(char));
	use(data); // GOOD
}
