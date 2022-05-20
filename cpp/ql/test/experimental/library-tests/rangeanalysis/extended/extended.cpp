

void test_overridability_sub(int x) {
  int zero = x - x;
  zero; // 0

  int nonzero = x - (unsigned char)x;
  nonzero; // full range
}
