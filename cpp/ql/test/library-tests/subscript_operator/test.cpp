// semmle-extractor-options: -std=c++23

struct S {
    int xs[2][2];
    int operator[](int i, int j) {
        return xs[i][j];
    }
};

int foo(S s) {
    return s[1, 2];
}
