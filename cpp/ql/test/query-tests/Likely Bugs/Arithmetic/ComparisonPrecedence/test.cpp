
/**
 * MyClass1 contains an `int` and has well behaved `operator<`
 */
class MyClass1 {
public:
	MyClass1() : v(0) {};
	MyClass1(int _v) : v(_v) {};

	bool operator<(const MyClass1 &other) {
		return v < other.v;
	}

	operator bool() {
		return true;
	}

	int v;
};

/**
 * MyClass2 contains an `int` but has an unusual `operator<`
 */
class MyClass2 {
public:
	MyClass2() : v(0) {};
	MyClass2(int _v) : v(_v) {};

	MyClass2 operator<(const MyClass2 &other) {
		return MyClass2(other.v);
	}

	operator bool() {
		return true;
	}

	int v;
};

void test1(int x, int y, int z) {
	// built-in comparison
	if (x < y < z) {} // BAD
	if (x > y > z) {} // BAD
	if (x <= y <= z) {} // BAD
	if (x <= y <= z) {} // BAD
	if (x < y > z) {} // BAD
	if ((x < y) && (y < z)) {} // GOOD
	if (x < y && y < z) {} // GOOD

	if ((x + 1) < (y + 1) < (z + 1)) {} // BAD
	if (x < x + y < z) {} // BAD

	if ((x < y) < z) {} // GOOD (this is deliberately allowed)
	if (!(x < y < z)) {} // BAD

	// overloaded comparison
	{
		MyClass1 a, b, c;

		if (a < b < c) {} // BAD (the overloaded `operator<` behaves like `<`) [NOT DETECTED]
	}

	// overloaded non-comparison
	{
		MyClass2 a, b, c;

		if (a < b < c) {} // GOOD (the overloaded `operator<` does not behave like `<`)
	}
}
