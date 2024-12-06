// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);
int fprintf();

void f(UNKNOWN_CHAR * str) {
    printf("%s", 1); // BAD
    printf("%s", implicit_function()); // GOOD - we should ignore the type
    sprintf(0, "%s", ""); // GOOD
    fprintf(0, "%s", ""); // GOOD
    printf("%s", str); // GOOD - erroneous type is ignored
}
