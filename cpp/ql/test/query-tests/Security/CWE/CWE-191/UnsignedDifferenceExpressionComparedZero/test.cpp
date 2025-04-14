int getAnInt();

bool cond();

void test(unsigned x, unsigned y, bool unknown) {
	if(x - y > 0) { } // BAD

	unsigned total = getAnInt();
	unsigned limit = getAnInt();
	while(limit - total > 0) { // BAD
		total += getAnInt();
	}

	if(total <= limit) {
		while(limit - total > 0) { // GOOD
			total += getAnInt();
			if(total > limit) break;
		}
	}

	if(x >= y) {
		bool b = x - y > 0; // GOOD
	}

	if((int)(x - y) >= 0) { } // GOOD. Maybe an overflow happened, but the result is converted to the "likely intended" result before the comparison

	if(unknown) {
		y = x & 0xFF;
	} else {
		y = x;
	}
	bool b1 = x - y > 0; // GOOD

	x = getAnInt();
	y = getAnInt();
	if(y > x) {
		y = x - 1;
	}
	bool b2 = x - y > 0; // GOOD

	int N = getAnInt();
	y = x;
	while(cond()) {
		if(unknown) { y--; }
	}

	if(x - y > 0) { } // GOOD

	x = y;
	while(cond()) {
		if(unknown) break;
		y--;
	}

	if(x - y > 0) { } // GOOD

	y = 0;
	for(int i = 0; i < x; ++i) {
		if(unknown) { ++y; }
	}

	if(x - y > 0) { } // GOOD [FALSE POSITIVE]

	x = y;
	while(cond()) {
		if(unknown) { x++; }
	}

	if(x - y > 0) { } // GOOD

	int n = getAnInt();
	if (n > x - y) { n = x - y; }
	if (n > 0) {
  	y += n; // NOTE: `n` is at most `x - y` at this point.
  	if (x - y > 0) {} // GOOD [FALSE POSITIVE]
	}
}

void test2() {
	unsigned int a = getAnInt();
	unsigned int b = a;

	if (a - b > 0) { // GOOD (as a = b)
		// ...
	}
}

void test3() {
	unsigned int a = getAnInt();
	unsigned int b = a - 1;

	if (a - b > 0) { // GOOD (as a >= b)
		// ...
	}
}

void test4() {
	unsigned int a = getAnInt();
	unsigned int b = a + 1;

	if (a - b > 0) { // BAD
		// ...
	}
}

void test5() {
	unsigned int b = getAnInt();
	unsigned int a = b;

	if (a - b > 0) { // GOOD (as a = b)
		// ...
	}
}

void test6() {
	unsigned int b = getAnInt();
	unsigned int a = b + 1;

	if (a - b > 0) { // GOOD (as a >= b)
		// ...
	}
}

void test7() {
	unsigned int b = getAnInt();
	unsigned int a = b - 1;

	if (a - b > 0) { // BAD
		// ...
	}
}

void test8() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (a - b > 0) { // BAD
		// ...
	}

	if (a >= b) { // GOOD
		if (a - b > 0) { // GOOD (as a >= b)
			// ...
		}
	} else {
		if (a - b > 0) { // BAD
			// ...
		}
	}

	if (b >= a) { // GOOD
		if (a - b > 0) { // BAD
			// ...
		}
	} else {
		if (a - b > 0) { // GOOD (as a > b)
			// ...
		}
	}

	while (a >= b) { // GOOD
		if (a - b > 0) { // GOOD (as a >= b)
			// ...
		}
	}

	if (a < b) return;

	if (a - b > 0) { // GOOD (as a >= b)
		// ...
	}
}

void test9() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (a < b) {
		b = 0;
	}

	if (a - b > 0) { // GOOD (as a >= b) [FALSE POSITIVE]
		// ...
	}
}

void test10() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (a < b) {
		a = b;
	}

	if (a - b > 0) { // GOOD (as a >= b)
		// ...
	}
}

void test11() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (a < b) return;

	b = getAnInt();

	if (a - b > 0) { // BAD
		// ...
	}
}

void test12() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();
	unsigned int c;

	if ((b <= c) && (c <= a)) {
		if (a - b > 0) { // GOOD (as b <= a)
			// ...
		}
	}

	if (b <= c) {
		if (c <= a) {
			if (a - b > 0) { // GOOD (as b <= a)
				// ...
			}
		}
	}
}

int test13() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (b != 0) {
		return 0;
	} // b = 0

	return (a - b > 0); // GOOD (as b = 0)
}

int test14() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (!b) {
		return 0;
	} // b != 0

	return (a - b > 0); // BAD
}

struct Numbers
{
	unsigned int a, b;
};

int test15(Numbers *n) {

	if (!n) {
		return 0;
	}

	return (n->a - n->b > 0); // BAD
}

int test16() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (!b) {
		return 0;
	} else {
		return (a - b > 0); // BAD
	}
}

int test17() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (b == 0) {
		return 0;
	} // b != 0

	return (a - b > 0); // BAD
}

int test18() {
	unsigned int a = getAnInt();
	unsigned int b = getAnInt();

	if (b) {
		return 0;
	} // b == 0

	return (a - b > 0); // GOOD (as b = 0)
}

typedef unsigned int uint32_t;
typedef long long int64_t;
uint32_t get_limit();
uint32_t get_data();

void test19() {
	// from the doc:
	uint32_t limit = get_limit();
	uint32_t total = 0;

	while (limit - total > 0) { // BAD: if `total` is greater than `limit` this will underflow and continue executing the loop.
		total += get_data();
	}

	while (total < limit) { // GOOD: never underflows here because there is no arithmetic.
		total += get_data();
	}

	while ((int64_t)limit - total > 0) { // GOOD: never underflows here because the result always fits in an `int64_t`.
		total += get_data();
	}
}

void test20(int a, bool b, unsigned long c)
{
  int x = 0;

  if(b) {
    x = (a - c) / 2;
  } else {
    x = a - c;
  }

  if (a - c - x > 0) // GOOD
  {
  }
}

uint32_t get_uint32();
int64_t get_int64();

void test21(unsigned long a)
{
  {
    int b = a & get_int64();
    if (a - b > 0) { } // GOOD
  }

  {
  int b = a - get_uint32();
  if(a - b > 0) { } // GOOD
  }

  {
    int64_t c = get_int64();
    if(c <= 0) {
      int64_t b = (int64_t)a + c;
      if(a - b > 0) { } // GOOD
    }
    int64_t b = (int64_t)a + c;
    if(a - b > 0) { } // BAD
  }

  {
    unsigned c = get_uint32();
    if(c >= 1) {
      int b = a / c;
      if(a - b > 0) { } // GOOD
    }
  }

  {
    int b = a >> get_uint32();
    if(a - b > 0) { } // GOOD
  }
}