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

#define va_list void*
#define va_start(x, y) x = 0;
#define va_arg(x, y) ((y)x)
#define va_end(x)
int vprintf(const char * format, va_list args);

int my_printf(const char * format, ...) {
    va_list args;
    va_start(args, format);
    int result = vprintf(format, args);
    va_end(args);
    return result;
}

void linker_awareness_test() {
    my_printf("%s%d", "", 1);  // GOOD
}
