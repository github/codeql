
typedef unsigned long size_t;
void *malloc(size_t size);

int getAnInt();

void test()
{
	int x = getAnInt();
	int y = getAnInt();

	char *buffer1 = (char *)malloc(x + y); // GOOD
	char *buffer2 = (char *)malloc(x * y); // BAD
	int *buffer3 = (int *)malloc(x * sizeof(int)); // GOOD
	int *buffer4 = (int *)malloc(x * y * sizeof(int)); // BAD

	if ((x <= 1000) && (y <= 1000))
	{
		char *buffer5 = (char *)malloc(x * y); // GOOD [FALSE POSITIVE]
	}

	size_t size1 = x * y;
	char *buffer5 = (char *)malloc(size1); // BAD

	size_t size2 = x;
	size2 *= y;
	char *buffer6 = (char *)malloc(size2); // BAD [NOT DETECTED]

	char *buffer7 = new char[x * 10]; // GOOD
	char *buffer8 = new char[x * y]; // BAD
	char *buffer9 = new char[x * x]; // BAD
}
