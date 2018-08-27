int test00(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1;
  x = p0 + p1; // Same value as previous line. Should the assignment also be matched?
  y = x;
}

int global01 = 1;

int test01(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global01;
  x = p0 + p1 + global01; // Same structure as previous line.
  y = x; // x is the same as x above
}

int global02 = 2;

void change_global02(); // Just a declaration

int test02(int p0, int p1) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global02;
  change_global02();
  x = p0 + p1 + global02; // same HashCons as above
  y = x;
}

int global03 = 3;

void change_global03(); // Just a declaration

int test03(int p0, int p1, int* p2) {
  int x, y;
  unsigned char b;

  x = p0 + p1 + global03;
  *p2 = 0;
  x = p0 + p1 + global03; // same HashCons as 43
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
    if (*ptr == '\0') { // ptr same as ptr on lines 53 and 56
      break;
    }
    result++;
  }

  return result; // result same as result on line 62
}

int getAValue();

struct two_values {
  signed short val1;
  signed short val2;
};

void test04(two_values *vals)
{
  signed short v = getAValue(); // should this match getAValue() on line 80?

  if (v < vals->val1 + vals->val2) {
    v = getAValue(); // should this match getAValue() on line 77?
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

void test06(int x) {
  x++;
  x++; // x++ is matched
}

// literals
void test07() {
  int x = 1;
  x = 1;
  x = 2;
  x = 2;
  x = 1 + 2;
  x = 1 + 2;

  char *str = "1";
  str = "1";
  str = "2";
  str = "2";

  float y = 0.0;
  y = 0.0;
  y = 0.5;
  y = 0.5;
}

void test08() {
  test07();
  test07();

  my_strspn("foo", "bar");
  my_strspn("foo", "bar");


  my_strspn("bar", "foo");
}

class IntHolder {
  int myInt;

  int getInt() {
    return myInt;
  }

public:
  int getDoubledInt() {
    return getInt() + this->getInt(); // getInt() and this->getInt() should be the same
  }
};

int test09(IntHolder ih) {
  return ih.getDoubledInt() + ih.getDoubledInt();
}

int test10(int x) {
  x++ + x++;
  x++ + x++; // same as above
  return ++x; // ++x is not the same as x++
}

void* test11() {
  nullptr == nullptr;
  return nullptr;
}
