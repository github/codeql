// Compilable with:
// gcc -c cast_specifiers.c

void f(void) {
    int x = 3;
    x = x;
    x = (int)x;
    x = (const long)x; // [MISSING: 'const', 'volatile' specifiers on casts on lines 8 .. 12]
    x = (volatile int)x; // [MISSING: implicit cast back to int]
    x = (const int)x; // [MISSING: implicit cast back to int]
    x = (const volatile int)x; // [MISSING: implicit cast back to int]
    x = (volatile const int)x; // [MISSING: implicit cast back to int]
}

