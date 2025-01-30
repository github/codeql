// semmle-extractor-options: --expect_errors --build-mode none

int printf(const char * format, ...);
int fprintf();

void f(UNKNOWN_CHAR * str) {
    printf("%s", 1); // BAD
    printf("%s", implicit_function()); // GOOD: we should ignore the type
    sprintf(0, "%s", ""); // GOOD
    fprintf(0, "%s", ""); // GOOD
    printf("%s", str); // GOOD: erroneous type is ignored
    printf("%d %d %u %u", 42l, 42ul, 42l, 42ul); // GOOD: build mode none
    printf("%d %d %u %u", 42ll, 42ull, 42ll, 42ull); // BAD
    printf("%ld %ld %lu %lu", 42, 42u, 42, 42u); // BAD
}
