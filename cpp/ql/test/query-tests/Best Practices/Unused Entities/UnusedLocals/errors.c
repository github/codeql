// semmle-extractor-options: --expect_errors
void f_error(void) {
    int x, z;
    // There is an error in here, so we don't see the use of x. But we
    // still don't want to report it as unused.
    z = y + x;
}

void g_error(void) {
    int x, y, z;
    // This one should be reported despite the error in another function.
    z = y + y;
}

