/* static f */

static void f(...) __attribute__((overloadable));

static int __attribute((overloadable)) f(int x) {
  return x;
}

static double __attribute((overloadable)) f(double x) {
  return x;
}

/* non-static g */

int __attribute__((overloadable)) g(int x) {
  return x;
}

double __attribute__((overloadable)) g(double x) {
  return x;
}

/* usages */

typedef struct foo { int x; } foo_t;

int main() {
  foo_t foo;
  f(foo);
  f(3);
  f(3.0);
  
  g(3);
  g(3.0);
  
  return 0;
}
