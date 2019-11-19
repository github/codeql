// Test for BadAdditionOverflowCheck.
bool checkOverflow1(unsigned short a, unsigned short b) {
  return (a + b < a);  // BAD: comparison always false (due to promotion).
}

// Test for BadAdditionOverflowCheck.
bool checkOverflow2(unsigned short a, unsigned short b) {
  return ((unsigned short)(a + b) < a);  // GOOD
}

// Test for PointlessSelfComparison.
bool selfCmp1(int x) {
  return (x == (int)x);  // BAD: always returns true.
}

// Test for PointlessSelfComparison.
bool selfCmp2(int x) {
  return (x == (char)x);  // GOOD: test that the cast does not overflow.
}

// Test for PointlessSelfComparison.
bool isnan(double x) {
  return (x != x);  // GOOD: NaN test.
}

// Tests for ComparisonWithCancelingSubExpr.
void cmpWithCancelingVar1(unsigned short x, unsigned short y, unsigned short z) {
  bool b;
  b = x + y < x + z;  // BAD: x can be canceled
  b = x + y - x < z;  // BAD: x can be canceled
  b = 2*x + y < 2*x + z;  // BAD: x can be canceled
  b = 3*x + y - 2*x < z + x;  // BAD: x can be canceled
  b = (-x) - (+x) < z - 2*x;  // BAD: x can be canceled
}

// Tests for ComparisonWithCancelingSubExpr.
void cmpWithCancelingVar2(int x, int y, int z) {
  bool b;
  b = x + y < x + z;  // GOOD: x cannot be canceled (possible overflow)
  b = x + y - x < z;  // GOOD: x cannot be canceled (possible overflow)
  b = 3*x + y - 2*x < z + x;  // GOOD: x cannot be canceled (possible overflow)
}

struct MyStruct {
  unsigned short a;
  unsigned short b;
};

// Regression test for false positive results for comparisons involving
// structure fields.
bool checkOverflow3(MyStruct *x, MyStruct *y, MyStruct *z) {
  return (x->a + y->b < z->a);  // GOOD: `x->a` is not the same as `z->a`.
}

// Regression test for false positive results for comparisons involving
// structure fields.
bool selfCmp2(MyStruct* x, MyStruct* y) {
  return (x->a == (int)(y->a));  // GOOD: `x->a` is not the same as `y->a`.
}

// Regression test for false positive result for an isNaN check in a
// template method.
template <typename T>
struct is_nan
{
  static bool call(T n)
  {
    return (n != n) ? true : false; // GOOD: does something useful for `is_nan<double>`.
  }
};

// Regression test for false positive result.
bool cmpWithCancelingVar3(int x) {
  return (x < 2*x);  // GOOD: x cannot be canceled (possible overflow)
}

bool selfCmp3(unsigned short x) {
  x++;
  return (x == (unsigned short)x);  // BAD: always returns true.
}

bool selfCmp4(int x) {
  while (x == x) // BAD: always returns true.
  {
    x = x + 1;
  }
}

bool selfCmp5(int x) {
  while (x == x) // BAD: always returns true. [NOT DETECTED]
  {
    x++;
  }
}

// This test is an example of code that used to lead to confusing results
// from `BadOverflowAdditionCheck.ql`. The problem was that the query was
// trying to be too clever by using range analysis. The overflow check here
// can never fail, because `a < 0xFFFF`, so the query identified it as a
// bad overflow check. But if you just look at the types, it is a perfectly
// good overflow check. We shouldn't penalize people for coding
// defensively.
bool checkOverflow3(unsigned int a, unsigned short b) {
  if (a >= 0xFFFF) {
    return false;
  }

  return (a + b < a);  // GOOD: b is automatically promoted to unsigned int
}

// We imagine that the next two lines come from a platform-specific header.
typedef unsigned long long size_t;
#define u64 unsigned long long

int isSmallEnough(unsigned long long x) {
  // The cast is to the same syntactic type, and there is no macro involved.
  // That makes the cast redundant, and therefore the comparison is redundant.
  if ((unsigned long long)x != x) { // BAD
    return 0;
  }
  // These comparisons are pointless on the platform where this test runs, but
  // code like this is often written to have an effect on some platforms and
  // get compiled away on others.
  return x == (size_t)x && x == (u64)x; // GOOD
}

#define markRange(str, x, y) \
	if ((x) == (y)) { \
		str[x] = '^'; \
	} else { \
		int i; \
		str[x] = '<'; \
		for (i = x + 1; i < y; i++) { \
			str[i] = '-'; \
		} \
		str[y] = '>'; \
	}

void useMarkRange(int offs) {
	char buffer[100];

	markRange(buffer, 10, 20);
	markRange(buffer, 30, 30);
	markRange(buffer, offs, offs + 10);
	markRange(buffer, offs, offs); // GOOD (comparison is in the macro)
}

#define MY_MACRO(x) (x)

void myMacroTest(int x) {
	MY_MACRO(x == x); // BAD
}
