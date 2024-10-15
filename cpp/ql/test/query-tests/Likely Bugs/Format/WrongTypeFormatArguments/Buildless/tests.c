// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);
int fprintf();

int f() {
    printf("%s", 1); // BAD - TP
    printf("%s", implicit_function()); // BAD (FP) - we should not infer the return type
    sprintf(0, "%s", ""); // BAD (FP)
    fprintf(0, "%s", ""); // BAD (FP)
}
