
void f(_Imaginary double x, _Imaginary double y) {
    double z;
    _Complex double w;
    z = x * y;
    z = z / y;
    w = z + x;
    w = x + z;
    w = z - x;
    w = x - z;
}

// codeql-extractor-compiler: cl
// codeql-extractor-compiler-options: -dsemmle--c99
