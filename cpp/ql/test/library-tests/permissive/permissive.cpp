// semmle-extractor-options: --edg --permissive
static void f(char* foo) {}

static void g(void) {
  const char* str = "foo";
  f(str);
}

