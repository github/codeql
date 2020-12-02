// semmle-extractor-options: --expect_errors
static void f(char* foo) {}

static void g(void) {
  const char* str = "foo";
  f(str);
}

