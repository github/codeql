bool checkArgument(int* x);

void sink(int);

void testCheckArgument(int* p) {
  if (checkArgument(p)) {
    sink(*p); // $ barrier=int indirect_barrier=int barrier=int* indirect_barrier=int*
  }
}

void testCheckArgument(int p) {
  if (checkArgument(&p)) {
    sink(p); // $ barrier=glval<int> indirect_barrier=glval<int> indirect_barrier=int
  }
}