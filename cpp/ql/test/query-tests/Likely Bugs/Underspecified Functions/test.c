void declared_empty();
void declared_void(void);
void declared_with(int);
void declared_empty_defined_with();
void declared_with_pointers();
void declared_with_array();
void declared_and_defined_empty();

int k_and_r_func(c,d)
  char c;
  double d;
{
  return c + d;
}

struct _s { int a, b; } s;

int ca[4] = { 1, 2, 3, 4 };

void *pv;

void test(int *argv[]) {
  declared_empty(); // GOOD
  declared_empty(1); // GOOD
  declared_void(); // GOOD
  declared_with(1); // GOOD
  
  undeclared();  // BAD (GOOD for everything except cpp/implicit-function-declaration)
  undeclared(1); // GOOD
  
  not_yet_declared1(1); // BAD (GOOD for everything except for cpp/implicit-function-declaration)
  not_yet_declared2(1); // BAD (GOOD for everything except for cpp/implicit-function-declaration)
  not_yet_declared2(ca); // BAD
  not_yet_declared2(); // BAD

  declared_empty_defined_with(); // BAD
  declared_empty_defined_with(1); // GOOD

  int x;
  declared_empty_defined_with(&x); // BAD
  declared_empty_defined_with(3, &x); // BAD

  not_declared_defined_with(-1, 0, 2U); // BAD (GOOD for everything except for cpp/implicit-function-declaration)
  not_declared_defined_with(4LL, 0, 2.5e9f); // BAD

  declared_with_pointers(pv, ca); // GOOD
  declared_with_pointers(3.5e15, 0); // BAD
  declared_with_array("Hello"); // GOOD
  declared_with_array(&x); // BAD
  
  defined_with_float(2.f);  // BAD
  defined_with_float(2.0);  // BAD
  
  defined_with_double(2.f); // BAD (GOOD for everything except for cpp/implicit-function-declaration)
  defined_with_double('c');  // BAD
  
  defined_with_long_long('c');  // BAD
  defined_with_long_long(3);    // BAD

  defined_with_double(2LL);  // BAD
  defined_with_long_long(3.5e15);  // BAD
  
  k_and_r_func(2.5, &s);  // GOOD
  
  int (*parameterName)[2];
  defined_with_ptr_ptr(parameterName); // // BAD (GOOD for everything except for cpp/implicit-function-declaration)
  defined_with_ptr_ptr(argv);   // GOOD
  defined_with_ptr_arr(parameterName); // // BAD (GOOD for everything except for cpp/implicit-function-declaration)
  defined_with_ptr_arr(argv);   // GOOD

  declared_and_defined_empty(); // GOOD
  declared_and_defined_empty(1);  // BAD
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

float defined_with_float(float f) {
  return f;
}

double defined_with_double(double d) {
  return d;
}

long long defined_with_long_long(long long ll) {
  return ll;
}

unsigned int defined_with_ptr_ptr(unsigned int **ptr) {
	return **ptr;
}
unsigned int defined_with_ptr_arr(unsigned int *ptr[]) {
	return **ptr;
}

void declared_and_defined_empty() {
	return;
}

extern int will_be_k_and_r();

int call_k_and_r(int i) {
	return will_be_k_and_r(i);  // GOOD
}

int will_be_k_and_r(val)
  int val;
{ return val + 1; }

extern int extern_definition(double, double*);

void test_implicit_function_declaration(int x, double d) {
  int y;
  implicit_declaration(1, 2); // BAD
  implicit_declaration_k_and_r(1, 2); // BAD

  implicit_declaration(1, 2); // GOOD (no longer an implicit declaration)

  y = extern_definition(3.0f, &d); // GOOD
}