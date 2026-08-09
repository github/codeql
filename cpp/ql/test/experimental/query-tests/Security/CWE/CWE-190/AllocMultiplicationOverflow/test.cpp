
typedef unsigned long size_t;
void *malloc(size_t size);

int getAnInt();

void test()
{
	int x = getAnInt();
	int y = getAnInt();

	char *buffer1 = (char *)malloc(x + y); // GOOD
	char *buffer2 = (char *)malloc(x * y); // $ Alert // BAD
	int *buffer3 = (int *)malloc(x * sizeof(int)); // GOOD
	int *buffer4 = (int *)malloc(x * y * sizeof(int)); // $ Alert // BAD

	if ((x <= 1000) && (y <= 1000))
	{
		char *buffer5 = (char *)malloc(x * y); // $ SPURIOUS: Alert // GOOD [FALSE POSITIVE]
	}

	size_t size1 = x * y; // $ Source
	char *buffer5 = (char *)malloc(size1); // $ Alert // BAD

	size_t size2 = x;
	size2 *= y;
	char *buffer6 = (char *)malloc(size2); // $ MISSING: Alert // BAD [NOT DETECTED]

	char *buffer7 = new char[x * 10]; // GOOD
	char *buffer8 = new char[x * y]; // $ Alert // BAD
	char *buffer9 = new char[x * x]; // $ Alert // BAD
}


// --- custom allocators ---

void *MyMalloc1(size_t size) { return malloc(size); } // $ Alert // [additional detection here]
void *MyMalloc2(size_t size);

void customAllocatorTests()
{
	int x = getAnInt();
	int y = getAnInt();

	char *buffer1 = (char *)MyMalloc1(x * y); // $ Alert Source // BAD
	char *buffer2 = (char *)MyMalloc2(x * y); // $ Alert // BAD
}
