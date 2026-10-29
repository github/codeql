// Semmle test case for rule ArithmeticUncontrolled.ql (Uncontrolled data in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

int rand(void);

int get_rand()
{
	return rand(); // $ Source
}

void get_rand2(int *dest)
{
	*dest = rand(); // $ Source
}

void get_rand3(int &dest)
{
	dest = rand(); // $ Source
}

void randomTester2()
{
	{
		int r = get_rand();
		r = r + 100; // $ Alert // BAD
	}

	{
		int r;
		get_rand2(&r);
		r = r + 100; // $ Alert // BAD
	}

	{
		int r;
		get_rand3(r);
		r = r + 100; // $ Alert // BAD
	}
}

int rand(int min, int max);
unsigned rand(int max);

void test_with_bounded_randomness() {
	int r = rand(0, 10);
	r++; // GOOD

	unsigned unsigned_r = rand(10);
	unsigned_r++; // GOOD
}

int test_remainder_subtract()
{
	int x = rand();
	int y = x % 100; // y <= x

	return x - y; // GOOD (as y <= x)
}

unsigned int test_remainder_subtract_unsigned()
{
	unsigned int x = rand(); // $ Source
	unsigned int y = x % 100; // y <= x

	return x - y; // $ SPURIOUS: Alert // GOOD (as y <= x) [FALSE POSITIVE]
}

typedef unsigned long size_t;
int snprintf(char *s, size_t n, const char *format, ...);

int test_buffer(char *buf_start, char *buf_end)
{
	int len = buf_end - buf_start;

	return len * 2; // GOOD
}

int test_snprintf(char *buf, size_t buf_sz)
{
	snprintf(buf, buf_sz, "my random number: %i\n", rand());
	test_buffer(buf, buf + buf_sz);
}

int test_else_1()
{
	int x = rand(); // $ Source

	if (x > 100)
	{
		return x * 10; // $ Alert // BAD
	} else {
		return x * 10; // GOOD (as x <= 100)
	}
}

int test_else_2()
{
	int x = rand(); // $ Source

	if (x > 100)
	{
		return x * 10; // $ Alert // BAD
	}

	return x * 10; // GOOD (as x <= 100)
}

int test_conditional_assignment_1()
{
	int x = rand();
	int y = 100;

	if (x < y)
	{
		y = x;
		return y * 10; // GOOD (as y <= 100)
	} else {
		return y * 10; // GOOD (as y = 100)
	}
}

int test_conditional_assignment_2()
{
	int x = rand();
	int y = 100;

	if (x < y)
	{
		y = x;
	}

	return y * 10; // GOOD (as y <= 100)
}

int test_conditional_assignment_3()
{
	int x = rand(); // $ Source
	int y = 100;
	int c = 10;

	if (x < y)
	{
		y = x;
	}

	return y * c; // $ SPURIOUS: Alert // GOOD (as y <= 100) [FALSE POSITIVE]
}

int test_underflow()
{
	int x = rand(); // $ Source
	int a = -x; // GOOD
	int b = 10 - x; // GOOD
	int c = b * 2; // $ Alert // BAD
}

int test_cast()
{
	int x = rand();
	short a = x; // $ MISSING: Alert // BAD [NOT DETECTED]
	short b = -x; // $ MISSING: Alert // BAD [NOT DETECTED]
	long long c = x; // GOOD
	long long d = -x; // GOOD
}

void test_float()
{
	{
		int x = rand(); // $ Source
		float y = x; // GOOD
		int z = (int)y * 5; // $ Alert // BAD
	}

	{
		int x = rand();
		float y = x * 5.0f; // GOOD
		int z = y; // $ MISSING: Alert // BAD [NOT DETECTED]
	}

	{
		int x = rand();
		float y = x / 10.0f; // GOOD
		int z = (int)y * 5; // GOOD
	}
}

void test_if_const_bounded()
{
	int x = rand(); // $ Source
	int y = rand(); // $ Source
	int c = 10;

	if (x < 1000)
	{
		x = x * 2; // GOOD
		x = x * c; // $ SPURIOUS: Alert // GOOD [FALSE POSITIVE]
	} else {
		x = x * 2; // $ Alert // BAD
		x = x * c; // $ Alert // BAD
	}

	if (y > 1000)
	{
		y = y * 2; // $ Alert // BAD
		y = y * c; // $ Alert // BAD
	} else {
		y = y * 2; // GOOD
		y = y * c; // $ SPURIOUS: Alert // GOOD [FALSE POSITIVE]
	}
}

void test_mod_limit()
{
	{
		int x = rand(); // $ Source
		int y = 100;
		int z;

		z = (x + y) % 1000; // $ Alert // BAD
	}

	{
		unsigned int x = rand();
		unsigned int y = 100;
		unsigned int z;

		z = (x + y) % 1000; // DUBIOUS (this could overflow but the result is controlled)
	}
}
