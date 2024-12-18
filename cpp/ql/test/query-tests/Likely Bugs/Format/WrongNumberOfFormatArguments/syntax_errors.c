// semmle-extractor-options: --expect_errors

extern int printf(const char *fmt, ...);

void test_syntax_error() {
    // GOOD
    printf("Error code %d: " UNDEFINED_MACRO, 0, "");

    // GOOD
    printf("%d%d",
        (UNDEFINED_MACRO)1,
        (UNDEFINED_MACRO)2);

    // GOOD [FALSE POSITIVE]
    printf("%d%d"
        UNDEFINED_MACRO,
        1, 2);
}
