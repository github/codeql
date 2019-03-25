void declared_empty();
void declared_void(void);
void declared_with(int);
void declared_empty_defined_with();

void test() {
  declared_empty(); // GOOD
  declared_empty(1); // BAD
  declared_void(); // GOOD
  declared_with(1); // GOOD
  
  undeclared();  // GOOD
  undeclared(1); // BAD
  
  not_yet_declared1(1); // BAD
  not_yet_declared2(1); // GOOD
  not_yet_declared2(); // BAD

  declared_empty_defined_with(); // BAD
  declared_empty_defined_with(1); // GOOD

  int x;
  declared_empty_defined_with(&x); // GOOD (type mismatch)
  declared_empty_defined_with(3.0f, &x); // BAD (type mismatch)

  not_declared_defined_with(1.0, 0, 2U); // GOOD (type mismatch)
  not_declared_defined_with(4LL, 0, 2); // GOOD (type mismatch)
}

void not_yet_declared1();
void not_yet_declared2(int);
void declared_empty_defined_with(int x) {
  // do nothing
}
void not_declared_defined_with(int x, int y, int z) {
  return;
}
