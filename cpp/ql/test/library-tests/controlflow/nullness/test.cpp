// semmle-extractor-options: -std=c++17

long __builtin_expect(long);
     
void f(int *v) {
    int *w;
    bool b, c;

    if (v) {}
    if (!v) {}
    if (v == 0) {}
    if ((!v) == 0) {}
    if (v != 0) {}
    if ((!v) != 0) {}
    if(__builtin_expect((long)v)) {}
    if(__builtin_expect((long)!v)) {}
    if (true && v) {}
    if (v && true) {}
    if (true && !v) {}
    if (!v && true) {}
    if (b = !v) {}
    if (c = !v; c) {}
    if (int *x = v; x) {}
    if (int *y = v) {}
}
