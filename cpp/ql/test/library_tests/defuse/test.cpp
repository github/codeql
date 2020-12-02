void use(int x);
int puts(const char* str);
void test1(int a0, int b0, int c0) {
  int a, b, c;
  a = a0;
  b = b0;
  c = c0;
  
  use(a);
  use(b);
  use(c);
  
  a = b;
  use(a);
  use(b);
  use(c);
  
  if (a < 0) {
    a = 1;
  } else {
    b = 1;
  }
  
  use(a);
  use(b);
  use(c);
  
  int d = a; // `a` is both a use of `a` and a def of `d`
  use(d);
  
  int e = d++; // `d++` is both a def of `d` and a def of `e`
  e = d++;
  use(d);
  use(e);
}

void assigns0(int& x);

void assigns1(int& x) {
  x = 42;
}

void assigns2(int* x) {
  int *y = x; *y = 42;
}

void assigns3(int* x) {
  assigns0(*x);
}

void test2() {
  int x = 0;
  assigns0(x);
  use(x);
}

void test3() {
  int x = 0;
  assigns1(x);
  use(x);
}

void test4() {
  int x = 0;
  assigns2(&x);
  use(x);
}

void test5() {
  int x = 0;
  assigns3(&x);
  use(x);
}

void nonAssigns0(int& x) { }

void nonAssigns1(int* x) { }

void test6() {
  int x = 0;
  nonAssigns0(x);
  use(x);
}

void test7() {
  int x = 0;
  nonAssigns1(&x);
  use(x);
}

void test8() {
  int x = 0;
  for (int i = 0; i < 2; i++) {
    use(x);
    x = 3;
  }
  use(x);
}

void test9() {
  int x = 0;
  bool done = false;
  while (!done) {
    use(x);
    x = 3;
    done = true;
  }
  use(x);
}

void test10() {
  int x = 0;
  for (int i = 0; i < 2; i++) {
    use(x);
    x = 3;
  }
  use(x);
  bool done = false;
  while (!done) {
    use(x);
    x = 3;
    done = true;
  }
  use(x);
}

void test11() {
  int x = 0;
  for (int i = 0; i < 2; i++) {
    use(x);
    x = 3;
    bool done = false;
    while (!done) {
      use(x);
      x = 3;
      done = true;
    }
    use(x);
  }
  use(x);
}

void test12() {
  int x = 0;
  int* y = &x;
  *y = 1;
  use(x);
}

void test13() {
  int x = 0;
  int& y = x;
  use(x);
  y = 1;
  use(x);
}

void test14(int x) {
  use(x);
  x = 42;
  use(x);
}

void reads_const_ref(const int &x) {
  use(x);
}

void reads_const_ptr(const int *x) {
  use(*x);
}

void test15(int x) {
  reads_const_ref(x);
  reads_const_ptr(&x);
  use(x);
}

struct S {
  int x_;
  struct Nested {
    int *yptr_, z_;
    static int static_y;
    Nested(int *yptr, int z) : yptr_(yptr), z_(z) {}
    Nested(int z) : yptr_(&static_y), z_(z) {}
  } nested;
};

S f(int x, int z) {
  static int y;
  S s = { x, { &y, z } };
  return s;
}
