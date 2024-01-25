int source(); char source(bool);
void sink(int); void sink(char);

void source_ref(int *toTaint) { // $ ir-def=*toTaint ast-def=toTaint
    *toTaint = source();
}
void source_ref(char *toTaint) { // $ ir-def=*toTaint ast-def=toTaint
    *toTaint = source();
}
void modify_copy(int* ptr) { // $ ast-def=ptr
  int deref = *ptr;
  int* other = &deref;
  source_ref(other);
}

void test_output_copy() {
   int x = 0;
   modify_copy(&x);
   sink(x); // clean
}

void modify(int* ptr) { // $ ast-def=ptr
  int* deref = ptr;
  int* other = &*deref;
  source_ref(other);
}

void test_output() {
   int x = 0;
   modify(&x);
   sink(x); // $ ir MISSING: ast
}

void modify_copy_of_pointer(int* p, unsigned len) { // $ ast-def=p
  int* p2 = new int[len];
  for(unsigned i = 0; i < len; ++i) {
    p2[i] = p[i];
  }

  source_ref(p2);
}

void test_modify_copy_of_pointer() {
  int x[10];
  modify_copy_of_pointer(x, 10);
  sink(x[0]); // $ SPURIOUS: ast // clean
}

void modify_pointer(int* p, unsigned len) { // $ ast-def=p
  int** p2 = &p;
  for(unsigned i = 0; i < len; ++i) {
    *p2[i] = p[i];
  }

  source_ref(*p2);
}

void test_modify_of_pointer() {
  int x[10];
  modify_pointer(x, 10);
  sink(x[0]); // $ ast,ir
}

char* strdup(const char* p);

void modify_copy_via_strdup(char* p) { // $ ast-def=p
  char* p2 = strdup(p);
  source_ref(p2);
}

void test_modify_copy_via_strdup(char* p) { // $ ast-def=p
  modify_copy_via_strdup(p);
  sink(*p); // $ SPURIOUS: ir
}

int* deref(int** p) { // $ ast-def=p
  int* q = *p;
  return q;
}

void test1() {
  int x = 0;
  int* p = &x;
  deref(&p)[0] = source();
  sink(*p); // $ ir MISSING: ast
}


void addtaint1(int* q) { // $ ast-def=q ir-def=*q
  *q = source();
}

void addtaint2(int** p) { // $ ast-def=p
  int* q = *p;
  addtaint1(q);
}

void test2() {
  int x = 0;
  int* p = &x;
  addtaint2(&p);
  sink(*p); // $ ir MISSING: ast
}
