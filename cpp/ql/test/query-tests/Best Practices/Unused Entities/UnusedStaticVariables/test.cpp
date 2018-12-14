
int globalVar; // GOOD (not static)
static int staticVar1; // GOOD (used)
static int staticVar2; // GOOD (used)
static int staticVar3 = 3; // GOOD (used)
static int staticVar4 = staticVar3; // GOOD (used)
static int staticVar5; // BAD (unused)
static int staticVar6 = 6; // BAD (unused)
static __attribute__((__unused__)) int staticVar7; // GOOD (unused but this is expected)

void f()
{
	int *ptr = &staticVar4;

	staticVar1 = staticVar2;
	(*ptr) = 0;
}

