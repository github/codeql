void test_crement() {
  int x1 = 0;
  ++x1;

  int x2 = 0;
  x2++;

  int x3 = 0;
  x3 -= 1; // flow

  int x4 = 0;
  x4 |= 1; // flow

  int x5 = 0;
  x5 = x5 - 1; // flow (to RHS)
}
