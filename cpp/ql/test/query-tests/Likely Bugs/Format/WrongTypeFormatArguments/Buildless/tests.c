// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);
int fprintf();

void f() {
    printf("%s", 1); // BAD
    printf("%s", implicit_function()); // GOOD - we should ignore the type
    sprintf(0, "%s", ""); // GOOD
    fprintf(0, "%s", ""); // GOOD
}
