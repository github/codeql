struct List {
  struct List* next;
};

int test1(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count = count+1;
  }
  return count;
}

int test2(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count = (count+1) % 10;
  }
  return count;
}

int test3(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count++;
    count = count % 10;
  }
  return count;
}

int test4() {
  int i = 0;
  int total = 0;
  for (i = 0; i < 2; i = i+1) {
    total += i;
  }
  return total + i;
}

int test5() {
  int i = 0;
  int total = 0;
  for (i = 0; i < 2; i++) {
    total += i;
  }
  return total + i;
}

int test6() {
  int i = 0;
  int total = 0;
  for (i = 0; i+2 < 4; i = i+1) {
    total += i;
  }
  return total + i;
}

int test7(int i) {
  if (i < 4) {
    if (i < 5) {
      return i;
    }
  }
  return 1;
}

int test8(int x, int y) {
  if (-1000 < y && y < 10) {
    if (x < y-2) {
      return x;
    }
  }
  return y;
}

int test9(int x, int y) {
  if (y == 0) {
    if (x < 4) {
      return 0;
    }
  } else {
    if (x < 4) {
      return 1;
    }
  }
  return x;
}

int test10(int x, int y) {
  if (y > 7) {
    if (x < y) {
      return 0;
    }
    return x;
  }
  return 1;
}

int test11(char *p) {
  char c;
  c = *p;
  if (c != '\0')
    *p++ = '\0';

  if (c == ':') {
    c = *p;
    if (c != '\0')
      *p++ = '\0';

    if (c != ',')
      return 1;
  }
  return 0;
}

typedef unsigned long long size_type;

size_type test12_helper() {
  static size_type n = 0;
  return n++;
}

int test12() {
   size_type Start = 0;
   while (Start <= test12_helper()-1)
   {
     const size_type Length = test12_helper();
     Start += Length + 1;
   }

   return 1;
}

// Tests for overflow conditions.
int test13(char c, int i) {
  unsigned char uc = c;
  unsigned int x = 0;
  unsigned int y = x-1;
  int z = i+1;
  return (double)(c + i + uc + x + y + z);
}

// Regression test for ODASA-6013.
int test14(int x) {
  int x0 = (int)(char)x;
  int x1 = (int)(unsigned char)x;
  int x2 = (int)(unsigned short)x;
  int x3 = (int)(unsigned int)x;
  char c0 = x;
  unsigned short s0 = x;
  return x0 + x1 + x2 + x3 + c0 + s0;
}

long long test15(long long x) {
  return (x > 0 && x == (int)x) ? x : -1;
}

// Tests for unary operators.
int test_unary(int a) {
  int total = 0;

  if (3 <= a && a <= 11) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (0 <= a && a <= 11) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= 11) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= 1) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= 0) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= -2) {
    int b = +a;
    int c = -a;
    total += b+c;
  }

  return total;
}


// Tests for multiplication.
int test_mult01(int a, int b) {
  int total = 0;

  if (3 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // 15 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= 23) {
    int r = a*b;  // -143 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= 0) {
    int r = a*b;  // -143 .. 0
    total += r;
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= -7) {
    int r = a*b;  // -143 .. -21
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult02(int a, int b) {
  int total = 0;

  if (0 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (0 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= 23) {
    int r = a*b;  // -143 .. 253
    total += r;
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= 0) {
    int r = a*b;  // -143 .. 0
    total += r;
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= -7) {
    int r = a*b;  // -143 .. 0
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult03(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // -391 .. 253
    total += r;
  }
  if (-17 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // -391 .. 253
    total += r;
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= 23) {
    int r = a*b;  // -391 .. 253
    total += r;
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= 0) {
    int r = a*b;  // -143 .. 221
    total += r;
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= -7) {
    int r = a*b;  // -143 .. 221
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult04(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= 0 && 5 <= b && b <= 23) {
    int r = a*b;  // -391 .. 0
    total += r;
  }
  if (-17 <= a && a <= 0 && 0 <= b && b <= 23) {
    int r = a*b;  // -391 .. 0
    total += r;
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= 23) {
    int r = a*b;  // -391 .. 221
    total += r;
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= 0) {
    int r = a*b;  // 0 .. 221
    total += r;
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= -7) {
    int r = a*b;  // 0 .. 221
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult05(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= -2 && 5 <= b && b <= 23) {
    int r = a*b;  // -391 .. -10
    total += r;
  }
  if (-17 <= a && a <= -2 && 0 <= b && b <= 23) {
    int r = a*b;  // -391 .. 0
    total += r;
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= 23) {
    int r = a*b;  // -391 .. 221
    total += r;
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= 0) {
    int r = a*b;  // 0 .. 221
    total += r;
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= -7) {
    int r = a*b;  // 14 .. 221
    total += r;
  }

  return total;
}

int test16(int x) {
  int d, i = 0;
  if (x < 0) {
    return -1;
  }

  while (i < 3) {
    i++;
  }
  d = i;
  if (x < 0) {  // Comparison is always false.
    if (d > -x) {  // Unreachable code.
      return 1;
    }
  }
  return 0;
}

// Test ternary expression upper bounds.
unsigned int test_ternary01(unsigned int x) {
  unsigned int y1, y2, y3, y4, y5, y6, y7, y8;
  y1 = x < 100 ? x : 10;  // y1 < 100
  y2 = x >= 100 ? 10 : x;  // y2 < 100
  y3 = 0;
  y4 = 0;
  y5 = 0;
  y6 = 0;
  y7 = 0;
  y8 = 0;
  if (x < 300) {
    y3 = x ?: 5; // y3 < 300
    y4 = x ?: 500; // y4 <= 500
    y5 = (x+1) ?: 500; // y5 <= 300
    y6 = ((unsigned char)(x+1)) ?: 5; // y6 < 256
    y7 = ((unsigned char)(x+1)) ?: 500; // y7 <= 500
    y8 = ((unsigned short)(x+1)) ?: 500; // y8 <= 300
  }
  return y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8;
}

// Test ternary expression lower bounds.
unsigned int test_ternary02(unsigned int x) {
  unsigned int y1, y2, y3, y4, y5;
  y1 = x > 100 ? x : 110;  // y1 > 100
  y2 = x <= 100 ? 110 : x;  // y2 > 100
  y3 = 1000;
  y4 = 1000;
  y5 = 1000;
  if (x >= 300) {
    y3 = (x-300) ?: 5; // y3 >= 0
    y4 = (x-200) ?: 5; // y4 >= 100
    y5 = ((unsigned char)(x-200)) ?: 5; // y6 >= 0
  }
  return y1 + y2 + y3 + y4 + y5;
}

// Test that nested ternary expressions of literals doesn't cause performance blow up.
double test_ternary_nested_of_literals(double m, double n, double o, double p, double q) {
  double a = m ? n ? o ? p ? q ? 0.47438827 : 0.14333887 : 0.35279203 : 0.39206458 : 0.21540225 : 0.40496805;
  double b = m ? n ? o ? p ? q ? 0.34183348 : 0.35334640 : 0.22247853 : 0.32661893 : 0.59270465 : 0.52977410;
  double c = m ? n ? o ? p ? q ? 0.77429603 : 0.31478084 : 0.31235514 : 0.05121256 : 0.79310745 : 0.67981451;
  double d = m ? n ? o ? p ? q ? 0.44729556 : 0.80599202 : 0.98997262 : 0.59952732 : 0.36976948 : 0.83866835;
  double e = m ? n ? o ? p ? q ? 0.49311828 : 0.90389911 : 0.10597712 : 0.21778426 : 0.72485966 : 0.68734874;
  double f = m ? n ? o ? p ? q ? 0.47452848 : 0.10786650 : 0.11884576 : 0.76164052 : 0.34808892 : 0.58440865;
  double g = m ? n ? o ? p ? q ? 0.02524326 : 0.82905046 : 0.95823075 : 0.12516558 : 0.85235179 : 0.36232384;
  double h = m ? n ? o ? p ? q ? 0.38708626 : 0.32876044 : 0.14963485 : 0.45041108 : 0.48640909 : 0.84331272;
  double i = m ? n ? o ? p ? q ? 0.15755063 : 0.77086833 : 0.26428481 : 0.14800508 : 0.37428143 : 0.05328182;
  double j = m ? n ? o ? p ? q ? 0.41736536 : 0.76826628 : 0.27643238 : 0.55679274 : 0.39468857 : 0.69072144;
  double k = m ? n ? o ? p ? q ? 0.88955345 : 0.29904824 : 0.76242583 : 0.20519110 : 0.88745559 : 0.81372798;
  double l = m ? n ? o ? p ? q ? 0.42186276 : 0.53843358 : 0.44996679 : 0.13204114 : 0.52031241 : 0.42762647;

  // Since the abstract interpretation of `+` produces a product of the bounds
  // of the input operands, `output` will have k^12 bounds, where `k` is the
  // number of bounds that each of the variables above have. This blows up
  // unless `k` is 1.
  double output = a + b + c + d + e + f + g + h + i + j + k + l;

  return output;
}

// Test the comma expression.
unsigned int test_comma01(unsigned int x) {
  unsigned int y = x < 100 ? x : 100;
  unsigned int y1;
  unsigned int y2;
  y1 = (++y, y);
  y2 = (y++, y += 3, y);
  return y1 + y2;
}

void out(int i);

void test17() {
  int i, j;

  i = 10;
  out(i); // 10

  i = 10;
  i += 10;
  out(i); // 20

  i = 40;
  i -= 10;
  out(i); // 30

  i = j = 40;
  out(i); // 40

  i = (j += 10);
  out(i); // 50

  i = 20 + (j -= 10);
  out(i); // 60
}

// Tests for unsigned multiplication.
int test_unsigned_mult01(unsigned int a, unsigned b) {
  int total = 0;

  if (3 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // 15 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && 13 <= b && b <= 23) {
    int r = a*b;  // 39 .. 253
    total += r;
  }

  return total;
}

int test_unsigned_mult02(unsigned b) {
  int total = 0;

  if (5 <= b && b <= 23) {
    int r = 11*b;  // 55 .. 253
    total += r;
  }
  if (0 <= b && b <= 23) {
    int r = 11*b;  // 0 .. 253
    total += r;
  }
  if (13 <= b && b <= 23) {
    int r = 11*b;  // 143 .. 253
    total += r;
  }

  return total;
}

unsigned long mult_rounding() {
  unsigned long x, y, xy;
  x = y = 1000000003UL; // 1e9 + 3
  xy = x * y;
  return xy; // BUG: upper bound should be >= 1000000006000000009UL
}

unsigned long mult_overflow() {
  unsigned long x, y, xy;
  x = 274177UL;
  y = 67280421310721UL;
  xy = x * y;
  return xy; // BUG: upper bound should be >= 18446744073709551617UL
}

unsigned long mult_lower_bound(unsigned int ui, unsigned long ul) {
  if (ui >= 10) {
    unsigned long result = (unsigned long)ui * ui;
    return result; // BUG: upper bound should be >= 18446744065119617025
  }
  if (ul >= 10) {
    unsigned long result = ul * ul;
    return result; // lower bound is correctly 0 (overflow is possible)
  }
  return 0;
}

unsigned long mul_assign(unsigned int ui) {
  if (ui <= 10 && ui >= 2) {
    ui *= ui + 0;
    return ui; // 4 .. 100
  }

  unsigned int uiconst = 10;
  uiconst *= 4;

  unsigned long ulconst = 10;
  ulconst *= 4;
  return uiconst + ulconst; // 40 .. 40 for both
}

int mul_by_constant(int i, int j) {
  if (i >= -1 && i <= 2) {
    i = 5 * i;
    out(i); // -5 .. 10

    i = i * -3;
    out(i); // -30 .. 15

    i *= 7;
    out(i); // -210 .. 105

    i *= -11;
    out(i); // -1155 .. 2310
  }
  if (i == -1) {
    i = i * (int)0xffFFffFF; // fully converted literal is -1
    out(i); // 1 .. 1
  }
  i = i * -1;
  out(   i); // -2^31 .. 2^31-1

  signed char sc = 1;
  i = (*&sc *= 2);
  out(sc); // demonstrate that we couldn't analyze the LHS of the `*=` above...
  out(i); // -128 .. 127 // ... but we can still bound its result by its type.

  return 0;
}


int notequal_type_endpoint(unsigned n) {
  out(n); // 0 ..

  if (n > 0) {
    out(n); // 1 ..
  }

  if (n != 0) {
    out(n); // 1 ..
  } else {
    out(n); // 0 .. 0
  }

  if (!n) {
    out(n); // 0 .. 0
  } else {
    out(n); // 1 ..
  }

  while (n != 0) {
    n--; // 1 ..
  }

  out(n); // 0 .. 0
}

void notequal_refinement(short n) {
  if (n < 0)
    return;

  if (n == 0) {
    out(n); // 0 .. 0
  } else {
    out(n); // 1 ..
  }

  if (n) {
    out(n); // 1 ..
  } else {
    out(n); // 0 .. 0
  }

  while (n != 0) {
    n--; // 1 ..
  }

  out(n); // 0 .. 0
}

void notequal_variations(short n, float f) {
  if (n != 0) {
    if (n >= 0) {
      out(n); // 1 .. [BUG: we can't handle `!=` coming first]
    }
  }

  if (n >= 5) {
    if (2 * n - 10 == 0) { // Same as `n == 10/2` (modulo overflow)
      return;
    }
    out(n); // 6 ..
  }

  if (n != -32768 && n != -32767) {
    out(n); // -32766 ..
  }

  if (n >= 0) {
    n  ? n : n; // ? 1..  : 0..0
    !n ? n : n; // ? 0..0 : 1..
  }
}

void two_bounds_from_one_test(short ss, unsigned short us) {
  // These tests demonstrate how the range analysis is often able to deduce
  // both an upper bound and a lower bound even when there is only one
  // inequality in the source. For example `signedInt < 4U` establishes that
  // `signedInt >= 0` since if `signedInt` were negative then it would be
  // greater than 4 in the unsigned comparison.

  if (ss < sizeof(int)) { // Lower bound added in `linearBoundFromGuard`
    out(ss); // 0 .. 3
  }

  if (ss < 0x8001) { // Lower bound removed in `getDefLowerBounds`
    out(ss); // -32768 .. 32767
  }

  if ((short)us >= 0) {
    out(us); // 0 .. 32767
  }

  if ((short)us >= -1) {
    out(us); // 0 .. 65535
  }

  if (ss >= sizeof(int)) { // test is true for negative numbers
    out(ss); // -32768 .. 32767
  }

  if (ss + 1 < sizeof(int)) {
    out(ss); // -1 .. 2
  }
}

void widen_recursive_expr() {
  int s;
  for (s = 0; s < 10; s++) {
    int result = s + s; // 0 .. 9 [BUG: upper bound is 15 due to widening]
    out(result); // 0 .. 18 [BUG: upper bound is 127 due to double widening]
  }
}

void guard_bound_out_of_range(void) {
  int i = 0;
  if (i < 0) {
    out(i); // unreachable [BUG: is -max .. +max]
  }

  unsigned int u = 0;
  if (u < 0) {
    out(u); // unreachable [BUG: is 0 .. +max]
  }
}

void test_mod(int s) {
  int s2 = s % 5;
  out(s2); // -4 .. 4
}

void exit(int);
void guard_with_exit(int x, int y) {
  if (x) {
    if (y != 0) {
      exit(0);
    }
  }
  out(y); // ..

  // This test ensures that we correctly identify
  // that the upper bound for y is max_int when calling `out(y)`.
  // The RangeSsa will place guardPhy on `out(y)`, and consequently there is no
  // frontier phi node at out(y).
}

void test(int x) {
  if (x >= 10) {
    return;
  }
  // The basic below has two predecessors.
label:
  out(x);
  goto label;
}

void test_overflow() {
  const int x = 2147483647; // 2^31-1
  const int y = 256;
  if ((x + y) <= 512) {
    out(x);
    out(y);
  }
}
