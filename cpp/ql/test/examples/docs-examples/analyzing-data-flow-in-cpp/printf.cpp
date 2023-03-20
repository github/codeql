int printf(const char * format, ...);

void test_printf(const char * fmt1, bool choice, const char * str) {
    printf("%s", str);
    printf(fmt1, str);
    printf(choice ? "%s" : "%s\n", str);

    return;

    printf("%s", str); // Unreachable
}
