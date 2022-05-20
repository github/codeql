int* maybe_null_func();

struct S {
  int i;
};

void f() {
  int* x1 = maybe_null_func();
  if (x1) *x1 = 0;
  
  int* x2 = maybe_null_func();
  if (x2) *x2 = 0;
  
  int* x3 = maybe_null_func();
  if (x3) *x3 = 0;
  
  int* x4 = maybe_null_func();
  if (x4) *x4 = 0;
  
  int* x5 = maybe_null_func();
  if (x5) *x5 = 0;
  
  int* x6 = maybe_null_func();
  if (x6) *x6 = 0;
  
  int* x7 = maybe_null_func();
  if (x7) *x7 = 0;
  
  int* x8 = maybe_null_func();
  *x8 = 0;
  
  int* x9 = maybe_null_func();
  struct S S = {.i = (x9 && *x9)};
}
