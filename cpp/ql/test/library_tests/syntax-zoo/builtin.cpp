// semmle-extractor-options: --clang

template<typename T>
T *addressof(T &x) noexcept {
    return __builtin_addressof(x);
}

void call_addressof() {
    int i;
    int *p = addressof(i); // Doesn't work in 1.18 extractor
}

void builtin_cpp(int x, int y) {
    void *ptr = __builtin_operator_new(x - y);
    __builtin_operator_delete(*&ptr);
}
