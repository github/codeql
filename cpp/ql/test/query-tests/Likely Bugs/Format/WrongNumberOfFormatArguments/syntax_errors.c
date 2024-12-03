// semmle-extractor-options: --expect_errors

extern int printf(const char *fmt, ...);

void test_syntax_error() {
    printf("Error code %d: " UNDEFINED_MACRO, 0, "");

    printf("%d%d",
        (UNDEFINED_MACRO)1,
        (UNDEFINED_MACRO)2);
}
