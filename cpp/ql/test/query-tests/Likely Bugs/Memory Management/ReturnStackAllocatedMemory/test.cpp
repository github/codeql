
class MyClass
{
public:
	int a, b;
};

MyClass makeMyClass()
{
	return { 0, 0 }; // GOOD
}

MyClass *test1()
{
	MyClass mc;

	return &mc; // BAD
}

MyClass *test2()
{
	MyClass mc;
	MyClass *ptr = &mc;

	return ptr; // BAD
}

MyClass *test3()
{
	MyClass mc;
	MyClass *ptr = &mc;
	ptr = nullptr;
	return ptr; // GOOD
}

MyClass *test4()
{
	MyClass mc;
	MyClass &ref = mc;

	return &ref; // BAD [NOT DETECTED]
}

MyClass &test5()
{
	MyClass mc;
	return mc; // BAD
}

int *test6()
{
	MyClass mc;

	return &(mc.a); // BAD
}

MyClass test7()
{
	MyClass mc;

	return mc; // GOOD
}

MyClass *test8()
{
	MyClass *mc = new MyClass;

	return mc; // GOOD
}

MyClass test9()
{
	return MyClass(); // GOOD
}

int test10()
{
	MyClass mc;

	return mc.a; // GOOD
}

MyClass *test11()
{
	MyClass *ptr;

	{
		MyClass mc;
		ptr = &mc;
	}

	return ptr; // BAD
}

MyClass *test12(MyClass *param)
{
	return param; // GOOD
}

MyClass *test13()
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

	return &(arr[10]); // BAD
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

int *returnThreadLocal() {
  thread_local int threadLocal;
  return &threadLocal; // GOOD
}

int returnDereferenced() {
  int localInt = 2;
  int &localRef = localInt;
  return localRef; // GOOD
}

typedef unsigned long size_t;
void *memcpy(void *s1, const void *s2, size_t n);

char *returnAfterCopy() {
  char localBuf[] = "Data";
  static char staticBuf[sizeof(localBuf)];
  memcpy(staticBuf, localBuf, sizeof(staticBuf));
  return staticBuf; // GOOD
}

void *conversionBeforeDataFlow() {
  int myLocal;
  void *pointerToLocal = (void *)&myLocal; // has conversion
  return pointerToLocal; // BAD
}

void *arrayConversionBeforeDataFlow() {
  int localArray[4];
  int *pointerToLocal = localArray; // has conversion
  return pointerToLocal; // BAD [NOT DETECTED]
}

int &dataFlowThroughReference() {
  int myLocal;
  int &refToLocal = myLocal; // has conversion
  return refToLocal; // BAD [NOT DETECTED]
}

int *&conversionInFlow() {
  int myLocal;
  int *p = &myLocal;
  int *&pRef = p; // has conversion in the middle of data flow
  return pRef; // BAD [NOT DETECTED]
}
