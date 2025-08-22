// semmle-extractor-options: --expect_errors

void f() {
    f();
    g();
}
