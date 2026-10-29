void test(int n) {
  int i = 0;
  if (n <= 0) {
    return;
  }
  while (1) {
    // GOOD: condition is true after n iterations.
    if (i == n) {
      break;
    }
    i++;
  }
}
