void test(char x);
void test(signed char x);
void test(unsigned char x);
void test(short x);
void test(unsigned short x);
void test(int x);
void test(unsigned int x);
void test(long x);
void test(unsigned long x);
void test(long long x);
void test(unsigned long long x);
void test(wchar_t x);

void literals() {
  test(-1);  // $strictlyNegative
  test(0);
  test(1);  // $strictlyPositive
  test(0x7fffffff);  // $strictlyPositive
  test((int)0x80000000);  // $strictlyNegative
}

void unsigned_types(unsigned char uc, unsigned short us, unsigned int ui, unsigned long ul, unsigned long long ull) {
  test(uc);  // $positive
  test(us);  // $positive
  test(ui);  // $positive
  test(ul);  // $positive
  test(ull);  // $positive
}

void testIncrement() {
  int x = -5;
  test(x);  // $strictlyNegative
  test(++x);  // $negative
  x = 0;
  test(++x);  // $strictlyPositive
  x = 5;
  test(++x);  // $strictlyPositive
}

void testGuards(int x) {
  if (x < 0) {
    test(x);  // $strictlyNegative
  }
  if (x > 0) {
    test(x);  // $strictlyPositive
  }
  if (x == 0) {
    test(x);
  }
}