void ComplexNumbers() {
  double r = 0.0;
  _Imaginary double i = 1.0;
  _Complex double c = 0.0;
  r = c;
  c = i;
  c = r;
}
// codeql-extractor-compiler: cl
// codeql-extractor-compiler-options: -dsemmle--c99
