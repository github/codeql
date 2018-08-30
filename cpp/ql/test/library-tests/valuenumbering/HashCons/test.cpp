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

enum t1 {
  e1x1 = 1,
  e1x2 = 2
};

enum t2 {
  e2x1 = 1,
  e2x2 = 2
};

int test12() {
  e1x1 == e2x1;
  e1x1 == e2x2;
  return e1x2;
}

#define SQUARE(x)  ((x) * (x))

int test13(int y) {
  return SQUARE(y + 1);
}

#define SQUARE(x) x * x

int test14(int y) {
  return SQUARE(y);
}

typedef struct {
  int x;
  char y;
} padded_t;

typedef struct {
  int x;
} int_holder;

typedef unsigned long size_t;

void *malloc(size_t size);

int test15(int x) {
  sizeof(padded_t);
  alignof(padded_t);
  sizeof(padded_t);
  sizeof(int_holder) + sizeof(int);
  alignof(int_holder) + alignof(int_holder);

  int_holder holder = {x: x};
  sizeof(holder.x) + sizeof(holder.x);
  sizeof(x);
  alignof(x) + alignof(x);
}

static void *operator new(size_t size, void *placement) {
  return placement;
}

static void *operator new(size_t size, size_t alignment, void *placement) {
  return placement;
}

static void *operator new(size_t size, size_t alignment) {
  return malloc(size);
}

static void *operator new[](size_t size, void *placement) {
  return placement;
}

static void *operator new[](size_t size, size_t alignment, void *placement) {
  return placement;
}

static void *operator new[](size_t size, size_t alignment) {
  return malloc(size);
}

void test16(int y, int z) {
  new int(1);
  new int(1);
  new int(2);

  int x;

  char *ptr1 = new char[sizeof(int)];
  char *ptr2 = new char[sizeof(int)];

  delete new(ptr1) IntHolder;
  delete new(ptr1) IntHolder;
  delete new(ptr2) IntHolder;

  delete new(32, ptr1) IntHolder;
  delete[] new(32, ptr1) IntHolder;
  new(32, ptr2) IntHolder;
  new(16, ptr1) IntHolder;

  new(32) IntHolder;
  new(32) IntHolder;

  new(32) IntHolder[10];
  new(32) IntHolder[10];

  delete[] new(32) int[2] {1, 2};
  delete[] new(32) int[2] {1, 2};
  delete[] new(32) int[2] {3, 4};
  new(32) int[2] {1, 1};
  new(32) int[2] {2, 2};

  new(32) int[2] {};
  new(32) int[2] {};
  new(32) int[3] {};

  new int[x];
  new int[x];
  new int[z];
}

typedef struct point{
  int x;
  int y;
} point_t;

void test17() {
  point_t p1 = {
    1,
    2
  };
  point_t p2 = {
    1,
    2
  };
  point_t p3 = {
    2,
    1
  };
}

void test18() {
  throw 1;
  throw 1;
  throw 2;
  throw 2;
  throw;
  throw;
}

void test19(int *x, int *y) {
  x[0];
  x[0];
  x[1];
  x[1];
  y[0];
  y[1];
}

void test20(int *x, int *y) {
  void (*test_18_p)() = &test18;
  void (*test_17_p)() = &test17;
  void (*test_19_p)(int *, int *) = &test19;
  test_18_p();
  test_18_p();
  test_17_p();

  test_19_p(x, y);
  test_19_p(x, y);
  test_19_p(y, x);
}

void test21(int x, int y) {
  x == y ? x : y;
  x == y ? x : y;
  y == x ? x : y;
  x == y ? y : x;
}
