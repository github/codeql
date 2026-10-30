// semmle-extractor-options: -std=c++17
int globalVar; // GOOD (not static)
static int staticVar1; // GOOD (used)
static int staticVar2; // GOOD (used)
static int staticVar3 = 3; // GOOD (used)
static int staticVar4 = staticVar3; // GOOD (used)
static int staticVar5; // $ Alert // BAD (unused)
static int staticVar6 = 6; // $ Alert // BAD (unused)
static __attribute__((__unused__)) int staticVar7; // GOOD (unused but this is expected)
const int constVar8 = 8; // $ Alert // BAD (const defaults to static)
extern const int constVar9 = 9; // GOOD
static int staticVar10 = 10; // $ SPURIOUS: Alert // GOOD [FALSE POSITIVE] (referenced in a never instantiated template)
[[maybe_unused]] static int staticVar11; // GOOD (explicitly marked as maybe_unused)

void f()
{
	int *ptr = &staticVar4;

	staticVar1 = staticVar2;
	(*ptr) = 0;
}

template<class T>
class MyTemplateClass // never instantiated
{
public:
	MyTemplateClass(int param = staticVar10)
	{
		// ...
	}
};

int initialize()
{
	return ++globalVar;
}

static int initialized = initialize(); // GOOD (initializer has a side effect)

struct WithConstructor
{
	WithConstructor() { ++globalVar; }
};

struct WithDestructor
{
	~WithDestructor() { ++globalVar; }
};

static WithConstructor constructed; // GOOD (constructor has a side effect)
static WithDestructor destructed; // GOOD (destructor has a side effect)
