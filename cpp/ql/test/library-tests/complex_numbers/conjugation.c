// semmle-extractor-options: -std=c99
void f(_Complex double x) {
    x = ~x;
}

