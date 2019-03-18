void declared_empty();
void declared_void(void);
void declared_with(int);

void test() {
  declared_empty(); // GOOD
  declared_empty(1); // BAD
  declared_void(); // GOOD
  declared_with(1); // GOOD
  
  declared_ellipsis(); // GOOD
  declared_ellipsis(2);  // GOOD

  undeclared(1); // GOOD
  
  not_yet_declared1(1); // BAD
  not_yet_declared2(1); // GOOD

  declared_empty_defined_with(); // BAD
  declared_empty_defined_with(1); // GOOD

  int x;
  declared_empty_defined_with(&x); // GOOD
  declared_empty_defined_with(x, x); // BAD
}

void not_yet_declared1();
void not_yet_declared2(int);
void declared_empty_defined_with(int x) {
  // do nothing
}
