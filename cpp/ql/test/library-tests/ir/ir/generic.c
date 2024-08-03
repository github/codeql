void foo(unsigned int x, int y) {
  unsigned int r;
  r = _Generic(r, unsigned int: x, int: y) + 1;
}

// // semmle-extractor-options: -std=c11
