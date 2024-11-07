int source(); char source(bool);
void sink(int); void sink(char);

void source_ref(int *toTaint) { // $ ir-def=*toTaint ast-def=toTaint
    *toTaint = source();
}
void source_ref(char *toTaint) { // $ ir-def=*toTaint ast-def=toTaint
    *toTaint = source();
}
void modify_copy(int* ptr) { // $ ast-def=ptr ir-def=*ptr
  int deref = *ptr;
  int* other = &deref;
  source_ref(other);
}

void test_output_copy() {
   int x = 0;
   modify_copy(&x);
   sink(x); // clean
}

void modify(int* ptr) { // $ ast-def=ptr ir-def=*ptr
  int* deref = ptr;
  int* other = &*deref;
  source_ref(other);
}

void test_output() {
   int x = 0;
   modify(&x);
   sink(x); // $ ir MISSING: ast
}

void modify_copy_of_pointer(int* p, unsigned len) { // $ ast-def=p ir-def=*p
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

void modify_pointer(int* p, unsigned len) { // $ ast-def=p ir-def=*p
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

void modify_copy_via_strdup(char* p) { // $ ast-def=p ir-def=*p
  char* p2 = strdup(p);
  source_ref(p2);
}

void test_modify_copy_via_strdup(char* p) { // $ ast-def=p ir-def=*p
  modify_copy_via_strdup(p);
  sink(*p); // clean
}

int* deref(int** p) { // $ ast-def=p ir-def=*p ir-def=**p
  int* q = *p;
  return q;
}

void flowout_test1() {
  int x = 0;
  int* p = &x;
  deref(&p)[0] = source();
  sink(*p); // $ ir MISSING: ast
}


void addtaint1(int* q) { // $ ast-def=q ir-def=*q
  *q = source();
}

void addtaint2(int** p) { // $ ast-def=p ir-def=*p ir-def=**p
  int* q = *p;
  addtaint1(q);
}

void flowout_test2() {
  int x = 0;
  int* p = &x;
  addtaint2(&p);
  sink(*p); // $ ir MISSING: ast
}

using size_t = decltype(sizeof(int));

void* memcpy(void* dest, const void* src, size_t);

void modify_copy_via_memcpy(char* p) { // $ ast-def=p ir-def=*p
  char* dest;
  char* p2 = (char*)memcpy(dest, p, 10);
  source_ref(p2);
}

void test_modify_copy_via_memcpy(char* p) { // $ ast-def=p ir-def=*p
  modify_copy_via_memcpy(p);
  sink(*p); // clean
}

// These functions from any real database. We add a dataflow model of
// them as part of dataflow library testing.
// `r = strdup_ptr_001`(p) has flow from **p to **r
// `r = strdup_ptr_011`(p) has flow from *p to *r, and **p to **r
// `r = strdup_ptr_111`(p) has flow from p to r, *p to *r, **p to **r
char** strdup_ptr_001(const char** p);
char** strdup_ptr_011(const char** p);
char** strdup_ptr_111(const char** p);

void source_ref_ref(char** toTaint) { // $ ast-def=toTaint ir-def=*toTaint ir-def=**toTaint 
  // source -> **toTaint
  **toTaint = source(true);
}

// This function copies the value of **p into a new location **p2 and then
// taints **p. Thus, **p does not contain tainted data after returning from
// this function.
void modify_copy_via_strdup_ptr_001(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  // **p -> **p2
  char** p2 = strdup_ptr_001(p);
  // source -> **p2
  source_ref_ref(p2);
}

void test_modify_copy_via_strdup_001(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  modify_copy_via_strdup_ptr_001(p);
  sink(**p); // clean
}

// This function copies the value of *p into a new location *p2 and then
// taints **p2. Thus, **p contains tainted data after returning from this
// function.
void modify_copy_via_strdup_ptr_011(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  // **p -> **p2 and *p -> *p2
  char** p2 = strdup_ptr_011(p);
  // source -> **p2
  source_ref_ref(p2);
}

void test_modify_copy_via_strdup_011(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  modify_copy_via_strdup_ptr_011(p);
  sink(**p); // $ ir MISSING: ast
}

char* source(int);

void source_ref_2(char** toTaint) { // $ ast-def=toTaint ir-def=*toTaint ir-def=**toTaint
  // source -> *toTaint
  *toTaint = source(42);
}

// This function copies the value of p into a new location p2 and then
// taints *p2. Thus, *p contains tainted data after returning from this
// function.
void modify_copy_via_strdup_ptr_111_taint_ind(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  // **p -> **p2, *p -> *p2, and p -> p2
  char** p2 = strdup_ptr_111(p);
  // source -> *p2
  source_ref_2(p2);
}

void sink(char*);

void test_modify_copy_via_strdup_111_taint_ind(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  modify_copy_via_strdup_ptr_111_taint_ind(p);
  sink(*p); // $ ir MISSING: ast
}

// This function copies the value of p into a new location p2 and then
// taints **p2. Thus, **p contains tainted data after returning from this
// function.
void modify_copy_via_strdup_ptr_111_taint_ind_ind(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  // **p -> **p2, *p -> *p2, and p -> p2
  char** p2 = strdup_ptr_111(p);
  // source -> **p2
  source_ref_ref(p2);
}

void sink(char*);

void test_modify_copy_via_strdup_111_taint_ind_ind(char** p) { // $ ast-def=p ir-def=*p ir-def=**p
  modify_copy_via_strdup_ptr_111_taint_ind_ind(p);
  sink(**p); // $ ir MISSING: ast
}