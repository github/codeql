// semmle-extractor-options: --edg --c++20

void test(void) {
    int x;
    if constexpr (true) {
        x = 1;
    } else {
        x = 2;
    }
    if constexpr (false) {
        x = 3;
    }
}

