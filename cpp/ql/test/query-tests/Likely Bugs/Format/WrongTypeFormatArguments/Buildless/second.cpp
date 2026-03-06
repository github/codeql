// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);

// defines type `myFunctionPointerType`, referencing `size_t`
typedef size_t (*myFunctionPointerType) ();

void test_size_t() {
    size_t s = 0;

    printf("%zd", s); // GOOD
    printf("%zi", s); // GOOD
    printf("%zu", s); // GOOD [FALSE POSITIVE]
    printf("%zx", s); // GOOD [FALSE POSITIVE]
    printf("%d", s); // BAD
    printf("%ld", s); // BAD
    printf("%lld", s); // BAD
    printf("%u", s); // BAD

    char buffer[1024];

    printf("%zd", &buffer[1023] - buffer); // GOOD
    printf("%zi", &buffer[1023] - buffer); // GOOD
    printf("%zu", &buffer[1023] - buffer); // GOOD
    printf("%zx", &buffer[1023] - buffer); // GOOD
    printf("%d", &buffer[1023] - buffer); // BAD
    printf("%ld", &buffer[1023] - buffer); // BAD [NOT DETECTED]
    printf("%lld", &buffer[1023] - buffer); // BAD [NOT DETECTED]
    printf("%u", &buffer[1023] - buffer); // BAD
}
