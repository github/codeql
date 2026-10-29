
template<typename T>
int f(T a) {
    return 5;
}

template<typename T>
void g(T t) {
    long l = 1;
    // This is a call to f(long), but as g is never called, we
    // never instantiate it. So f(long) has a definition, but not
    // a body.
    f(l);
}

void h(int x) {
    f(x);
}

