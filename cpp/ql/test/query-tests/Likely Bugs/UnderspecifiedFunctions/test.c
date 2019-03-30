void declared_empty();
void declared_void(void);
void declared_with(int);
void declared_empty_defined_with();
void declared_with_pointers();
void declared_with_array();

struct _s { int a, b; } s;

int ca[4] = { 1, 2, 3, 4 };

void *pv;

void test() {
  declared_empty(); // GOOD
  declared_empty(1); // BAD
  declared_void(); // GOOD
  declared_with(1); // GOOD
  
  undeclared();  // GOOD
  undeclared(1); // BAD
  
  not_yet_declared1(1); // BAD
  not_yet_declared2(1); // GOOD
  not_yet_declared2(ca); // BAD
  not_yet_declared2(); // BAD

  declared_empty_defined_with(); // BAD
  declared_empty_defined_with(1); // GOOD

  int x;
  declared_empty_defined_with(&x); // BAD
  declared_empty_defined_with(3.0f, &x); // BAD

  not_declared_defined_with(1.0, 0, 2U); // GOOD
  not_declared_defined_with(4LL, 0, 2.5e9); // GOOD

  declared_with_pointers(pv, ca); // GOOD
  declared_with_pointers(3.5e15, 0); // BAD
  declared_with_array("Hello"); // GOOD
  declared_with_array(&x); // BAD
}

void not_yet_declared1();
void not_yet_declared2(int);
void declared_empty_defined_with(int x) {
  // do nothing
}
void not_declared_defined_with(int x, int y, int z) {
  return;
}

int dereference();

int caller(void) {
  return dereference(); // BAD
}

int dereference(int *x) { return *x; }

void declared_with_pointers(int *x, void *y);
void declared_with_array(char a [6]);

