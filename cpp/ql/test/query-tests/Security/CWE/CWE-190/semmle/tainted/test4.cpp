// Regression test for a false positive result from IntegerOverflowTainted.
// The expression `!p[0]` casts `p[0]`, which is a
// `char`, to `bool`. A cast to `bool` is not the same as a cast to
// a different integer type, such as uint8_t, because it is implemented
// by comparing the value to 0. This means that the cast cannot overflow,
// regardless of what the input type is.

int main4(int argc, char **argv) {
  char *p = argv[0];
  if (!p[0]) {  // GOOD: cast to bool.
    return 1;
  }
  if ((unsigned)p[1] == 0) {  // BAD: cast to unsigned could overflow.
    return 2;
  }
  if ((bool)p[2] != 0 || !p[3] == 1) {  // GOOD: casts to bool.
    return 3;
  }
  return 4;
}
