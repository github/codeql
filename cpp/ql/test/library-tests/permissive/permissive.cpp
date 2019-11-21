// codeql-extractor-compiler-options: -fpermissive
static void f(char* foo) {}

static void g(void) {
  const char* str = "foo";
  f(str);
}

