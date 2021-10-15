// file1.c

int globalInt1; // BAD [only accessed in this file]
int globalInt2; // GOOD [accessed in file1.c and file2.c]
int globalInt3; // GOOD [referenced in file1.h]
int globalInt4; // GOOD [only accessed in one function, should be function scope instead]
int globalInt5; // GOOD [not accessed]

static int staticInt1; // GOOD [static]

void file1Func1()
{
	globalInt1++;
	globalInt2++;
	globalInt3++;
	globalInt4++;
	staticInt1++;
}

void file1Func2()
{
	globalInt1++;
	globalInt3++;
	staticInt1++;
}
