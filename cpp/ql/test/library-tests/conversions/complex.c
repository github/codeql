void ComplexNumbers() {
  double r = 0.0;
  _Imaginary double i = 1.0;
  _Complex double c = 0.0;
  r = c;
  c = i;
  c = r;
}
// semmle-extractor-options: --microsoft -std=c99
