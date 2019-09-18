int f(int x, int y) {
  if (x < 0) {
    return x;
  }
  if (x < y) {
   return y; // y is strictly positive because of the bound on x above
  }
  return 0;
}

int g(int x, int y) {
  if (x < y) {
    return y;
  }
  if (x < 0) {
    return x;
  }
  return 0;
}
