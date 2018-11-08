int f(int x, int y) {
  if (x < 0) {
    return x;
  }
  if (x < y) {
   return y; // y is strictly positive because of the bound on x above
  }
  return 0;
}
