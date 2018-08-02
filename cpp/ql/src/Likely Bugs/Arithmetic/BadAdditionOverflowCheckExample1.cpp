bool checkOverflow(unsigned short x, unsigned short y) {
  return (x + y < x);  // BAD: x and y are automatically promoted to int.
}
