bool checkArgument(int* x);

void sink(int);

void testCheckArgument(int* p) {
  if (checkArgument(p)) {
    sink(*p); // $ barrier barrier=1
  }
}