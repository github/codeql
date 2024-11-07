// semmle-extractor-options: --expect_errors

extern int printf(const char *fmt, ...);

void test_syntax_error() {
    printf("Error code %d: " FMT_MSG, 0, "");
}
