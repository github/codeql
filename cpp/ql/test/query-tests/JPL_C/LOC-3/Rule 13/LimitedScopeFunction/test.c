// test.c

#include "test.h"

int globalInt1; // GOOD [used in func1, func2]
int globalInt2; // GOOD [used in func1, func2]
int globalInt3; // GOOD [used in func1, func2]
int globalInt4; // BAD [only used in func1]
int globalInt5; // BAD [only used in func1]
int globalInt6; // BAD [only used in func1]
int globalInt7; // GOOD [not used, should be reported by another query]
int globalInt8; // GOOD [used at file level]
int *addrGlobalInt8 = &globalInt8; // GOOD [used in func1, func2]
int globalInt9; // GOOD [used at file level and in func1]
int *addrGlobalInt9 = &globalInt9; // GOOD [used in func1, func2]

int externInt; // GOOD [extern'd so could be part of an interface]

void func1()
{
	int *ptr3 = &globalInt3;
	int *ptr6 = &globalInt6;
	int i8 = *addrGlobalInt8;

	globalInt1 = globalInt2;
	globalInt4 = globalInt5;
	externInt = globalInt9;
}

void func2()
{
	int *ptr1 = &globalInt3;
	int i8 = *addrGlobalInt8;

	globalInt1 = globalInt2;
}

void func3()
{
	static int staticInt; // GOOD [declared in local scope]
	int i;

	i = staticInt;
}
