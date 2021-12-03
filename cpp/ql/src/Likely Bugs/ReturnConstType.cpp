// The leftmost const has no effect here.
const int square(const int x) {
  return x * x;
}

// The const has no effect here, and can easily be mistaken for const char*.
char* const id(char* s) {
  return s;
}
