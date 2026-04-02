// semmle-extractor-options: --expect_errors

int printf(const char * format, ...);

// defines type `myFunctionPointerType`, referencing `size_t`
typedef size_t (*myFunctionPointerType) ();

void test_size_t() {
    size_t s = 0;

    printf("%zd", s); // GOOD
    printf("%zi", s); // GOOD
    printf("%zu", s); // GOOD (we generally permit signedness changes)
    printf("%zx", s); // GOOD (we generally permit signedness changes)
    printf("%d", s); // BAD [NOT DETECTED]
    printf("%ld", s); // DUBIOUS [NOT DETECTED]
    printf("%lld", s); // DUBIOUS [NOT DETECTED]
    printf("%u", s); // BAD [NOT DETECTED]

    char buffer[1024];

    printf("%zd", &buffer[1023] - buffer); // GOOD
    printf("%zi", &buffer[1023] - buffer); // GOOD
    printf("%zu", &buffer[1023] - buffer); // GOOD
    printf("%zx", &buffer[1023] - buffer); // GOOD
    printf("%d", &buffer[1023] - buffer); // BAD
    printf("%ld", &buffer[1023] - buffer); // DUBIOUS [NOT DETECTED]
    printf("%lld", &buffer[1023] - buffer); // DUBIOUS [NOT DETECTED]
    printf("%u", &buffer[1023] - buffer); // BAD
    // (for the `%ld` and `%lld` cases, the signedness and type sizes match, `%zd` would be most correct
    //  and robust but the developer may know enough to make this safe)
}
