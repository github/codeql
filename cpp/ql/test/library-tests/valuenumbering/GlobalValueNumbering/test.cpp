int test00(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1;
  x = p0 + p1; // Same value as previous line.
  y = x;
}

int global01 = 1;

int test01(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global01;
  x = p0 + p1 + global01; // Same value as previous line.
  y = x;
}

int global02 = 2;

void change_global02(); // Just a declaration

int test02(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global02;
  change_global02(); // Might change global02
  x = p0 + p1 + global02; // Not the same value
  y = x;
}

int global03 = 3;

void change_global03(); // Just a declaration

int test03(int p0, int p1, int* p2) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global03;
  *p2 = 0; // Might change global03
  x = p0 + p1 + global03; // Not the same value
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
