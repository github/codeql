extern "C" void free(void *ptr);
extern "C" int strcmp(const char *s1, const char *s2);

void test0(int *x) {
  if (x) // BAD
    free(x);
}

void test1(int *x) {
  if (x) { // BAD
    free(x);
  }
}

void test2(int *x) {
  if (x) { // GOOD: x is being accessed in the body of the if
    *x = 42;
    free(x);
  }
}

void test3(int *x, bool b) {
  if (x) { // GOOD: x is being accessed in the body of the if
    if (b)
      *x = 42;
    free(x);
  }
}

bool test4(char *x, char *y) {
  if (!x || strcmp(x, y)) { // GOOD: x is being accessed in the guard and return value depends on x
    free(x);
    return true;
  }
  free(x);
  return false;
}

void test5(char *x) {
  if (x)
    *x = 42;
  if (x) { // BAD
    free(x);
  }
}

void test6(char *x) {
  *x = 42;
  if (x) { // BAD
    free(x);
  }
}

void test7(char *x) {
  if (x || x) { // BAD [NOT DETECTED]
    free(x);
  }
}

bool test8(char *x) {
  if (x) { // GOOD: return value depends on x
    free(x);
    return true;
  }
  return false;
}

#ifdef FOO
#define my_free(x) free(x - 1)
#else
#define my_free(x) free(x)
#endif

void test9(char *x) {
  if (x) { // GOOD: macro may make free behave unexpectedly when compiled differently
    my_free(x);
  }
}

void test10(char *x) {
  if (x) { // GOOD: #ifdef may make free behave unexpectedly when compiled differently
#ifdef FOO
    free(x - 1);
#else
    free(x);
#endif
  }
}

#define TRY_FREE(x) \
  if (x) free(x);

void test11(char *x) {
  TRY_FREE(x) // BAD [NOT DETECTED]
}

bool test12(char *x) {
  if (!x) // GOOD: return value depends on x
    return false;

  free(x);
  return true;
}

void test13(char *x) {
  if (x != nullptr) // BAD
    free(x);
}

void inspect(char *x);

void test14(char *x) {
  if (x != nullptr) // GOOD: x might be accessed in the first operand of the comma operator
    inspect(x), free(x);
}
