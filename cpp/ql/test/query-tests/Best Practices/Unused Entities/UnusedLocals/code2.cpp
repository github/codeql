// semmle-extractor-options: -std=c++17

int test_const_init()
{
	int v1; // BAD: unused
	int v2; // GOOD
	int v3 = 0; // BAD: unused
	int v4 = 0; // GOOD
	const int v5 = 0; // BAD: unused [NOT DETECTED]
	const int v6 = 0; // GOOD
	constexpr int v7 = 0; // BAD: unused
	constexpr int v8 = 0; // GOOD
	
	return v2 + v4 + v6 + v8;
}

// ---

template<int i>
void myFunction()
{
}

void test_template_parameter()
{
	constexpr int v1 = 0; // BAD: unused
	constexpr int v2 = 0; // GOOD: used as a template parameter below [FALSE POSITIVE]

	myFunction<v2>();
}

// ---

class MyBuffer
{
public:
	unsigned char buffer[40];
};

void test_unused()
{
	MyBuffer myVar1; // BAD: unused
	MyBuffer myVar2; // GOOD: used in deliberate void cast below
	MyBuffer myVar3 __attribute((__unused__)); // GOOD: unused but acknowledged
	
	(void)myVar2;
}

// ---

#define likely(x) __builtin_expect ((x), 1)
#define unlikely(x) __builtin_expect ((x), 0)

static int getter() {}

void test_expect()
{
	int i;

	for (i = 0; i < 100000; i++)
	{
		int v1 = getter(); // GOOD: v1 is used
		int v2 = getter(); // GOOD: v2 is used
		int v3 = getter(); // BAD: unused

		if (unlikely(v1 < 0))
		{
			int a = i;
			int b = a;
			a += b;
			b = -1;
			break;
		}
		if (__builtin_expect(v2, 0))
		{
			break;
		}
	}
}

// ---

template<class T>
class MyContainer
{
public:
	struct Iterator {
		const T& operator*() const;
		bool operator!=(const Iterator &rhs) const;
		Iterator operator++();
	};

	Iterator begin();
	Iterator end();
};

void output(int value);

void test_range_based_for()
{
	MyContainer<int> myContainer;
	
	for (int v1 : myContainer) // GOOD: v1 is used
	{
		output(v1);
	}
	
	for (int v2 : myContainer) // BAD: v2 is not used
	{
	}
}

// ---

int test_lambdas1()
{
	int a, b, c, d, e; // (b is not used, but is explicitly captured)
	auto myLambda = [a, b, &c](int x, int y) -> int // (y is not used, but is a parameter)
	{
		return a + c + x;
	};

	return myLambda(d, e);
}

int test_lambdas2()
{
	int a, b; // BAD: b is not used
	auto myLambda = [=]() -> int // BAD: myLambda is not used [NOT DETECTED] (due to containing a Constructor)
	{
		return a;
	};

	return 0;
}

// ---

void test_if_initializer()
{
	bool a = false, b = true; // GOOD: a, b are both used

	if (a = b; a)
	{
		// ...
	}
}

// ---

class MyObj
{
public:
	MyObj();
};

template<class T>
void myFunction2(T t);

void test_captured_contructor()
{
	const auto &obj = MyObj(); // GOOD: obj is used

	myFunction2( [obj](){} );
}
