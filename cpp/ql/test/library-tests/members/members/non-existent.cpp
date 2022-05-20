// semmle-extractor-options: --expect_errors
struct S { void f(int); };
void S::f(char) {}

