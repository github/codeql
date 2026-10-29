static const int* xptr;

void example1() {
  int x = 0;
  xptr = &x; // BAD: address of local variable stored in non-local memory.
}

void example2() {
  static const int x = 0;
  xptr = &x; // GOOD: storing address of static variable is safe.
}
