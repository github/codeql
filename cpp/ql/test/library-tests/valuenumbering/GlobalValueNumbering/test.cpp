void test00(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1;
  x = p0 + p1; // Same value as previous line.
  y = x;
}

int global01 = 1;

void test01(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global01;
  x = p0 + p1 + global01; // Same value as previous line.
  y = x;
}

int global02 = 2;

void change_global02(); // Just a declaration

void test02(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global02;
  change_global02(); // Might change global02
  x = p0 + p1 + global02; // Not the same value
  y = x;
}

int global03 = 3;

void change_global03(); // Just a declaration

void test03(int p0, int p1, int* p2) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global03;
  *p2 = 0; // Might change global03
  x = p0 + p1 + global03; // BUG: Not the same value, but given the same value number (this is likely due to #2696)
  y = x;
}

unsigned int my_strspn(const char *str, const char *chars) {
  const char *ptr;
  unsigned int result = 0;

  while (*str != '\0') {
    // check *str against chars
    ptr = chars;
    while ((*ptr != *str) && (*ptr != '\0')) {ptr++;}

    // update
    if (*ptr == '\0') {
      break;
    }
    result++;
  }

  return result;
}

int getAValue();

struct two_values {
  signed short val1;
  signed short val2;
};

void test04(two_values *vals)
{
  signed short v = getAValue();

  if (v < vals->val1 + vals->val2) {
    v = getAValue();
  }
}

void test05(int x, int y, void *p)
{
  int v;

  v = p != 0 ? x : y;
}

int regression_test00() {
  int x = x = 10;
  return x;
}

struct Base {
  int b;
};

struct Derived : Base {
  int d;
};

int inheritanceConversions(Derived* pd) {
  int x = pd->b;
  Base* pb = static_cast<Base*>(pd);
  int y = pb->b;

  return y;
}

void test06() {
  "a";
  "b";
  "a";
  "c";
}

struct A {
  int x;
  int y;
};

void test_read_arg_same(A *pa, int n) {
  int b = pa->x;
  int c = pa->x;

  pa->x = n;
  int d = pa->x;
}

A* global_a;
int global_n;

void test_read_global_same() {
  int b = global_a->x;
  int c = global_a->x;

  global_a->x = global_n;
  int d = global_a->x;
}

void test_read_arg_different(A *pa) {
  int b = pa->x;
  int c = pa->y;

  pa->y = global_n;

  int d = pa->x;
}

void test_read_global_different(int n) {
  int b = global_a->x;
  int c = global_a->x;

  global_a->y = n;

  int d = global_a->x;
}