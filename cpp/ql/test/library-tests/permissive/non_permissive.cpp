// codeql-extractor-compiler-options: -Xsemmle--expect_errors
static void f(char* foo) {}

static void g(void) {
  const char* str = "foo";
  f(str);
}

