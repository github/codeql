static const int* xptr;

void localAddressEscapes() {
  int x = 0;
  xptr = &x;
}

void example1() {
  localAddressEscapes();
  const int* x = xptr; // BAD: This pointer points to expired stack allocated memory.
}

void localAddressDoesNotEscape() {
  int x = 0;
  xptr = &x;
  // ...
  // use `xptr`
  // ...
  xptr = nullptr;
}

void example2() {
  localAddressDoesNotEscape();
  const int* x = xptr; // GOOD: This pointer does not point to expired memory.
}
