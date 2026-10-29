int test01(int x, int y) {
  int b = x > 10 && y < 0;
  if (b) {
    return x;
  } else {
    return y;
  }
}
