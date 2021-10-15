// Test for reference types.
int test0(int &p) {
  int x = p;
  int y = 0;
  int& r0 = p;
  int& r1 = x;
  int& r2 = r1;
  int* q = &r2;
  for (int i = 0; i < 10; i++) {
    r2++;
    *q = *q + 1;
    if (i > 5) {
      r1--;
    }
  }
  return r0 + r1 + r2 + *q;
}

void test_helper1(int& x) {
  x++;
}

void test_helper2(int* x) {
  (*x)++;
}

typedef const int const_int;
typedef const int& const_int_ref;
typedef const int* const_int_ptr;

// Test for safe forms of address taking.
int test1() {
  int x = 1;
  int y = 2;
  const int& r1 = x;
  const_int& r2 = x;
  const_int_ref r3 = x;
  const int* p1 = &y;
  const_int* p2 = &y;
  const_int_ptr p3 = &y;
  test_helper1(x);
  test_helper2(&x);
  return x + r1 + r2 + r3 + *p1 + *p2 + *p3;
}

int test2() {
  int x = 1;
  volatile const_int& r = x;
  return x;
}

// Test for constructor field initializers (ODASA-5773). We do not
// currently get SSA edges from the parameters of the constructor to their
// uses in the constructor field initializers. This is because the
// constructor field initializers are not currently connected to the
// control flow graph, which is a bug because initializers can have
// side-effects.
class Test2 {
  Test2 *nextp_;
  Test2 &nextr_;
  const Test2 *nextcp_;
  const Test2 &nextcr_;
  int i_;
  int *ip_;
  int &ir_;
  const int ci_;
  const int *cip_;
  const int &cir_;

public:
  Test2(
    Test2 *nextp,
    Test2 &nextr,
    const Test2 *nextcp,
    const Test2 &nextcr,
    int i,
    int *ip,
    int &ir,
    const int ci,
    const int *cip,
    const int &cir
  ) :
    nextp_(nextp),
    nextr_(nextr),
    nextcp_(nextcp),
    nextcr_(nextcr),
    i_(i),
    ip_(ip),
    ir_(ir),
    ci_(ci),
    cip_(cip),
    cir_(cir)
  {}
};
