// semmle-extractor-options: --edg --c99
void f(_Complex double x) {
    x = ~x;
}

