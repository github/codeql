void test(int n) {
  int i = 0;
  if (n <= 0) {
    return;
  }
  while (1) {
    // BAD: condition is never true, so loop will not terminate.
    if (i == n) {
      break;
    }
  }
}
