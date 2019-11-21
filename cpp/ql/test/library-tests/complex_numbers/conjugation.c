// codeql-extractor-compiler-options: -std=c99
void f(_Complex double x) {
    x = ~x;
}

