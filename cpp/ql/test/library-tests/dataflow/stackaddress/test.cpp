void sink_i(int*);
void sink_v(void*);

void test000() {
  int x;
  sink_i(&x);
  sink_v(&x);
}

void test001() {
  int x;
  int *p = &x;
  sink_i(p);
  sink_v(p);
}

void test002_helper(int *p) {
  int *q = p;
  sink_i(q);
  sink_v(q);
}

void test002() {
  int x;
  int *p = &x;
  test002_helper(p);
}

void test100() {
  int x[10];
  sink_i(x);
  sink_i(x+2);
  sink_v(x);
}

void test101() {
  int x[10];
  int *p = x;
  sink_i(p);
  sink_i(p-2);
  sink_v(p);
}

void test102() {
  int x[10];
  int *p = &x[2];
  sink_i(p);
  sink_v(p);
}

void test103() {
  int x[10];
  void *p = x;
  sink_v(p);
}

void test104_helper(int *p) {
  int *q = p;
  sink_i(q);
  sink_i(q+2);
  sink_v(q);
}

void test104() {
  int x[10];
  test104_helper(x);
  test104_helper(x-2);
}

void test200() {
  int* p = new int[10];
  sink_i(p);
  sink_v(p);
}

void test300() {
  int x[3][4][5];
  sink_i(&x[0][0][0]);
  sink_v(&x[0][0][0]);

  int (*p)[3][4][5] = &x;
  sink_i(&((*p)[0][0][0]));
  sink_v(&((*p)[0][0][0]));
}

void test301_helper(int x[4][5]) {
  sink_i(&x[0][0]);
  sink_v(&x[0][0]);
}

void test301() {
  int x[3][4][5];
  test301_helper(x[0]);
}

void test302() {
  int x[3][4][5];
  sink_v(x);
}
