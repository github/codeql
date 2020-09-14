
// Regression test. The AsmStmt might modify the arguments, which are passed by
// reference.

// Helper function for regression_test_00, below.
static void modify_args(unsigned int& a, unsigned int& b, unsigned int& c, unsigned int& d)
{
#if defined(__GNUC__)
  __asm__ __volatile__
    (
  "cpuid\n\t"
    : "+a" (a), "+b" (b), "+c" (c), "+d" (d)
    );
#else
  a++;
  b++;
  c++;
  d++;
#endif
}

int regression_test_00() {
  unsigned int a = 0, b = 0, c = 0, d = 0;
  modify_args(a, b, c, d);

  const unsigned int x = a;

  // 'a' might have been modified by the call to 'modify_args',
  // so we do not know if this condition is true or false.
  if (x >= 1)
  {
    return true;
  }
  return false;
}


static const unsigned int e = -1;

void test_e(int f) {
  if (f == e) { // GOOD
    // ...
  }
}





#define MAX_VAL ((size_t) -1)
typedef unsigned int size_t;

static int foo(size_t *size)
{
  int bar;

  if (*size <= MAX_VAL) // BAD (pointless comparison) [NO LONGER REPORTED]
    *size = MAX_VAL;
}

// ODASA-7205
int regression_test_01(unsigned long bb) {
  if (bb + 1 == 0) { // GOOD [NO LONGER REPORTED]
    return 0;
  } else {
    return 1;
  }
}

int containsIfDef(int x) {
  int result = 0;
  if (x > 0) {
    result = 1;
  }
#if _CONDITION
  if (x < 0) {
    result = -1;
  }
#endif

  return result >= 0;
}

void negativeZero1(int val) {
  if (val >= 0)
  {
    val = -val;
  }
  if (val == 0) // GOOD [NO LONGER REPORTED]
    ;
}

void negativeZero2(int val) {
  if (val >= 0)
  {
    val = 0 - val;
  }
  if (val == 0) // GOOD
    ;
}

void negativeZero3(int val) {
  if (val >= 0)
  {
    val *= -1;
  }
  if (val == 0) // GOOD [NO LONGER REPORTED]
    ;
}

void negativeZero4(int val) {
  if (val >= 0)
  {
    val = val * -1;
  }
  if (val == 0) // GOOD [NO LONGER REPORTED]
    ;
}
