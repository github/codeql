// codeql-extractor-compiler-options: -Xsemmle--expect_errors
struct S { void f(int); };
void S::f(char) {}

