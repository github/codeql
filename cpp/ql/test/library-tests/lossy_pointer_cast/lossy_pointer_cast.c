
void f(void) {
    void *p1, *p2, *p3, *p4;

    short int i;
    long long int z;

    z = (long long int)p1;            // OK: long long int is big enough
    i = (short int)p2;                // Bad: short is too small
    i = (short int)(long long int)p3; // OK: we assume they know what
                                      //     they are doing if they go
                                      //     via a large-enough type
    i = (short int)(void *)p4;        // Bad: Going via a pointer type is
                                      //      not convincing
}

