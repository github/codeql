struct S100 {
  int i;
  int* p;
};


int test100() {
  int x = 0;
  struct S100 s100;
  // GOOD: address is only written to another stack variable, which is
  // safe.
  s100.p = &x;
  return x;
}

static struct S100 s101;

int test101() {
  int x = 0;
  // BAD: local address is written to a static variable, which could
  // be unsafe.
  s101.p = &x;
  return x;
}

int test102() {
  int x = 0;
  static struct S100 s102;
  // BAD: local address is written to a local static variable, which could
  // be unsafe.
  s102.p = &x;
  return x;
}

void test103(int *p) {
  static struct S100 s103;
  // BAD: address is written to a local static variable, which could
  // be unsafe.
  s103.p = p;
}

// Helper for test103.
void test103_caller1(int *p) {
  test103(p);
}

// Helper for test103.
void test103_caller2() {
  int x = 0;
  test103_caller1(&x);
}

void test104(int *p) {
  static struct S100 s104;
  // GOOD: a stack address does not flow here, so this assignment is safe.
  s104.p = p;
}

void test104_caller1(int *p) {
  test104(p);
}

void test104_caller2() {
  static int x = 0;
  test104_caller1(&x);
}

// Test for pointer arithmetic.
int test105() {
  int x = 0;
  int* p0 = &x;
  int* p1 = p0 + 1;
  int* p2 = p1 - 1;
  int* p3 = 1 + p2;
  p3++;
  // BAD: local address is written to a static variable, which could
  // be unsafe.
  s101.p = p3;
  return x;
}

static struct S100 s106;

// Test for taking the address of a field.
void test106() {
  S100 s;
  // BAD: local address is written to a static variable, which could
  // be unsafe.
  s106.p = &(s.i);
}

// Test for reference types.
int test107() {
  int x = 0;
  int& r0 = x;
  int& r1 = r0;
  r1++;
  // BAD: local address is written to a static variable, which could
  // be unsafe.
  s101.p = &r1;
  return r1;
}

struct S200 {
  int i;
  union {
    void* p;
    const char* str;
  };
};

int test200() {
  int x = 0;
  struct S200 s200;
  // GOOD: address is only written to another stack variable, which is
  // safe.
  s200.p = &x;
  return x;
}

static struct S200 s201;

int test201() {
  int x = 0;
  // BAD: local address is written to a static variable, which could
  // be unsafe.
  s201.p = &x;
  return x;
}

int test202() {
  int x = 0;
  static struct S200 s202;
  // BAD: local address is written to a local static variable, which could
  // be unsafe.
  s202.p = &x;
  return x;
}

// Example used in qhelp.
static const int* xptr;

void example1() {
  int x = 0;
  xptr = &x; // BAD: address of local variable stored in non-local memory.
}

void example2() {
  static const int x = 0;
  xptr = &x; // GOOD: storing address of static variable is safe.
}

struct S300 {
  int a1[15];
  int a2[14][15];
  int a3[13][14][15];
  int *p1;
  int (*p2)[15];
  int (*p3)[14][15];
  int** pp;
};

void test301() {
  static S300 s;
  int b1[15];
  int b2[14][15];
  int b3[13][14][15];

  s.p1 = b1;      // BAD: address of local variable stored in non-local memory.
  s.p1 = &b1[1];  // BAD: address of local variable stored in non-local memory.

  s.p2 = b2;         // BAD: address of local variable stored in non-local memory.
  s.p2 = &b2[1];     // BAD: address of local variable stored in non-local memory.
  s.p1 = b2[1];      // BAD: address of local variable stored in non-local memory.
  s.p1 = &b2[1][2];  // BAD: address of local variable stored in non-local memory.

  s.p3 = b3;            // BAD: address of local variable stored in non-local memory.
  s.p3 = &b3[1];        // BAD: address of local variable stored in non-local memory.
  s.p2 = b3[1];         // BAD: address of local variable stored in non-local memory.
  s.p2 = &b3[1][2];     // BAD: address of local variable stored in non-local memory.
  s.p1 = b3[1][2];      // BAD: address of local variable stored in non-local memory.
  s.p1 = &b3[1][2][3];  // BAD: address of local variable stored in non-local memory.

  s.pp[0] = b1;            // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &b1[1];        // BAD: address of local variable stored in non-local memory.
  s.pp[0] = b2[1];         // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &b2[1][2];     // BAD: address of local variable stored in non-local memory.
  s.pp[0] = b3[1][2];      // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &b3[1][2][3];  // BAD: address of local variable stored in non-local memory.
}

void test302() {
  S300 s;
  int b1[15];
  int b2[14][15];
  int b3[13][14][15];

  s.p1 = b1;      // GOOD: address is only stored in another local variable
  s.p1 = &b1[1];  // GOOD: address is only stored in another local variable

  s.p2 = b2;         // GOOD: address is only stored in another local variable
  s.p2 = &b2[1];     // GOOD: address is only stored in another local variable
  s.p1 = b2[1];      // GOOD: address is only stored in another local variable
  s.p1 = &b2[1][2];  // GOOD: address is only stored in another local variable

  s.p3 = b3;            // GOOD: address is only stored in another local variable
  s.p3 = &b3[1];        // GOOD: address is only stored in another local variable
  s.p2 = b3[1];         // GOOD: address is only stored in another local variable
  s.p2 = &b3[1][2];     // GOOD: address is only stored in another local variable
  s.p1 = b3[1][2];      // GOOD: address is only stored in another local variable
  s.p1 = &b3[1][2][3];  // GOOD: address is only stored in another local variable

  // Even though s is local, we don't know that s.pp is local because
  // there is a pointer indirection involved.
  s.pp[0] = b1;            // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &b1[1];        // BAD: address of local variable stored in non-local memory.
  s.pp[0] = b2[1];         // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &b2[1][2];     // BAD: address of local variable stored in non-local memory.
  s.pp[0] = b3[1][2];      // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &b3[1][2][3];  // BAD: address of local variable stored in non-local memory.
}

void test303() {
  static S300 s;
  S300 x;

  s.p1 = x.a1;      // BAD: address of local variable stored in non-local memory.
  s.p1 = &x.a1[1];  // BAD: address of local variable stored in non-local memory.

  s.p2 = x.a2;         // BAD: address of local variable stored in non-local memory.
  s.p2 = &x.a2[1];     // BAD: address of local variable stored in non-local memory.
  s.p1 = x.a2[1];      // BAD: address of local variable stored in non-local memory.
  s.p1 = &x.a2[1][2];  // BAD: address of local variable stored in non-local memory.

  s.p3 = x.a3;            // BAD: address of local variable stored in non-local memory.
  s.p3 = &x.a3[1];        // BAD: address of local variable stored in non-local memory.
  s.p2 = x.a3[1];         // BAD: address of local variable stored in non-local memory.
  s.p2 = &x.a3[1][2];     // BAD: address of local variable stored in non-local memory.
  s.p1 = x.a3[1][2];      // BAD: address of local variable stored in non-local memory.
  s.p1 = &x.a3[1][2][3];  // BAD: address of local variable stored in non-local memory.

  // Even though s is local, we don't know that s.pp is local because
  // there is a pointer indirection involved.
  s.pp[0] = x.a1;            // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &x.a1[1];        // BAD: address of local variable stored in non-local memory.
  s.pp[0] = x.a2[1];         // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &x.a2[1][2];     // BAD: address of local variable stored in non-local memory.
  s.pp[0] = x.a3[1][2];      // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &x.a3[1][2][3];  // BAD: address of local variable stored in non-local memory.
}

void test304() {
  S300 s;
  S300 x;

  s.p1 = x.a1;      // GOOD: address is only stored in another local variable
  s.p1 = &x.a1[1];  // GOOD: address is only stored in another local variable

  s.p2 = x.a2;         // GOOD: address is only stored in another local variable
  s.p2 = &x.a2[1];     // GOOD: address is only stored in another local variable
  s.p1 = x.a2[1];      // GOOD: address is only stored in another local variable
  s.p1 = &x.a2[1][2];  // GOOD: address is only stored in another local variable

  s.p3 = x.a3;            // GOOD: address is only stored in another local variable
  s.p3 = &x.a3[1];        // GOOD: address is only stored in another local variable
  s.p2 = x.a3[1];         // GOOD: address is only stored in another local variable
  s.p2 = &x.a3[1][2];     // GOOD: address is only stored in another local variable
  s.p1 = x.a3[1][2];      // GOOD: address is only stored in another local variable
  s.p1 = &x.a3[1][2][3];  // GOOD: address is only stored in another local variable

  // Even though s is local, we don't know that s.pp is local because
  // there is a pointer indirection involved.
  s.pp[0] = x.a1;            // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &x.a1[1];        // BAD: address of local variable stored in non-local memory.
  s.pp[0] = x.a2[1];         // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &x.a2[1][2];     // BAD: address of local variable stored in non-local memory.
  s.pp[0] = x.a3[1][2];      // BAD: address of local variable stored in non-local memory.
  s.pp[0] = &x.a3[1][2][3];  // BAD: address of local variable stored in non-local memory.
}

struct S400 {
  int* p0;
  int* p1[10];
  int* p2[10][11];
  int** q1;
  int** q2[10];
  int** q3[10][11];
  int* (*r2)[11];
  int* (*r3)[11][12];

  S400() {
    q1 = new int*[10];
    for (int i = 0; i < 10; i++) {
      q2[i] = new int*[11];
    }
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 11; j++) {
        q3[i][j] = new int*[12];
      }
    }
    r2 = new int*[10][11];
    r3 = new int*[10][11][12];
  }
};

int test400() {
  S400 s;
  int x = 0;
  s.p0 = &x;           // GOOD: s.p0 is on the stack.
  s.p1[1] = &x;        // GOOD: s.p1 is on the stack.
  s.p2[1][2] = &x;     // GOOD: s.p1 is on the stack.
  s.q1[1] = &x;        // BAD: pointer indirection to the heap.
  s.q2[1][2] = &x;     // BAD: pointer indirection to the heap.
  s.q3[1][2][3] = &x;  // BAD: pointer indirection to the heap.
  s.r2[1][2] = &x;     // BAD: pointer indirection to the heap.
  s.r3[1][2][3] = &x;  // BAD: pointer indirection to the heap.
  return x;
}

class ListOnStack {
  int i_;
  ListOnStack *parent1_;
  ListOnStack *parent2_;
public:
  ListOnStack(int i, ListOnStack *parent)
    : i_(i), parent1_(parent)
  {
    // The assignment below is safe, because ListOnStack is always
    // allocated on the stack, so it cannot outlive the pointer.
    parent2_ = parent; // GOOD.
  }
};

void test500_impl(int n, ListOnStack *parent) {
  if (n > 0) {
    ListOnStack curr(n, parent);
    test500_impl(n-1, &curr);
  }
}

void test500() {
  test500_impl(10, 0);
}

class BaseClass600 {
  int *p_;
public:
  BaseClass600(int* p) {
    p_ = p;
  }
};

class DerivedClass600 : public BaseClass600 {
public:
  DerivedClass600(int* p) : BaseClass600(p) {}
};

void test600() {
  int i = 0;
  DerivedClass600 x(&i);
}

class BaseClass601 {
  int *p_;
public:
  BaseClass601(int* p) {
    p_ = p;
  }
};

class DerivedClass601 : public virtual BaseClass601 {
public:
  DerivedClass601(int* p) : BaseClass601(p) {}
};

void test601() {
  int i = 0;
  DerivedClass601 x(&i);
}

class DelegatingClass602 {
  int *p_;
  DelegatingClass602(int* p) : p_(p) {}
public:
  DelegatingClass602(int* p, int, int) : DelegatingClass602(p) {}
};

void test602() {
  int i = 0;
  DelegatingClass602 x(&i, 0, 0);
}

class BaseClass602 {
  int *p_;
public:
  BaseClass602(int* p) {
    p_ = p;
  }
};

class FieldInitClass602 {
  BaseClass602 base;
public:
  FieldInitClass602(int* p) : base(p) {}
};

void test603() {
  int i = 0;
  FieldInitClass602 x(&i);
}
