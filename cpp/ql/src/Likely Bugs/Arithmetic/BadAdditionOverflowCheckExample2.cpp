bool checkOverflow(unsigned short x, unsigned short y) {
  return ((unsigned short)(x + y) < x);  // GOOD: explicit cast
}
