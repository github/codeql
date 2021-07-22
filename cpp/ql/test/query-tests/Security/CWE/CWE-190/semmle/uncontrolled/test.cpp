// Semmle test case for rule ArithmeticUncontrolled.ql (Uncontrolled data in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

int rand(void);

int get_rand()
{
	return rand();
}

void get_rand2(int *dest)
{
	*dest = rand();
}

void get_rand3(int &dest)
{
	dest = rand();
}

void randomTester2()
{
	{
		int r = get_rand();
		r = r + 100; // BAD
	}

	{
		int r;
		get_rand2(&r);
		r = r + 100; // BAD
	}

	{
		int r;
		get_rand3(r);
		r = r + 100; // BAD
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