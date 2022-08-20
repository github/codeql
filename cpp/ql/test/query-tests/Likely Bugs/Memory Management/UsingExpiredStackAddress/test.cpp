struct S100 {
  int i;
  int* p;
};

static struct S100 s101;

void escape1() {
  int x;
  s101.p = &x;
}

int simple_field_bad() {
  escape1();
  return *s101.p; // BAD
}

int simple_field_good() {
  escape1();
  return s101.i; // GOOD
}

int deref_p() {
  return *s101.p; // BAD
}

int field_indirect_bad() {
  escape1();
  return deref_p();
}

int deref_i() {
  return s101.i;
}

int field_indirect_good() {
  escape1();
  return deref_i(); // GOOD
}

void store_argument(int *p) {
  s101.p = p;
}

int store_argument_value() {
  int x;
  store_argument(&x);
  return *s101.p; // GOOD
}

void store_address_of_argument(int y) {
  s101.p = &y;
}

int store_argument_address() {
  int x;
  store_address_of_argument(x);
  return *s101.p; // BAD
}

void address_escapes_through_pointer_arith() {
  int x[2];
  int* p0 = x;
  int* p1 = p0 + 1;
  int* p2 = p1 - 1;
  int* p3 = 1 + p2;
  p3++;
  s101.p = p3;
}

int test_pointer_arith_bad() {
  address_escapes_through_pointer_arith();
  return *s101.p; // BAD
}

int test_pointer_arith_good_1() {
  int x;
  address_escapes_through_pointer_arith();
  s101.p = &x;
  return *s101.p; // GOOD
}

int test_pointer_arith_good_2(bool b) {
  int x;
  if(b) {
    address_escapes_through_pointer_arith();
  }
  return *s101.p; // GOOD (we can't say for sure that this is a local address)
}

void field_address_escapes() {
  S100 s;
  s101.p = &s.i;
}

int test_field_address_escapes() {
  field_address_escapes();
  return s101.p[0]; // BAD
}

void escape_through_reference() {
  int x = 0;
  int& r0 = x;
  int& r1 = r0;
  r1++;
  s101.p = &r1;
}

int test_escapes_through_reference() {
  escape_through_reference();
  return *s101.p; // BAD
}

struct S300 {
  int a1[15];
  int a2[14][15];
  int a3[13][14][15];
  int *p1;
  int (*p2)[15];
  int (*p3)[14][15];
  int** pp;
};

S300 s1;
S300 s2;
S300 s3;
S300 s4;
S300 s5;
S300 s6;

void escape_through_arrays() {
  int b1[15];
  int b2[14][15];
  int b3[13][14][15];

  s1.p1 = b1;
  s2.p1 = &b1[1];

  s1.p2 = b2;
  s2.p2 = &b2[1];
  s3.p1 = b2[1];
  s4.p1 = &b2[1][2];

  s1.p3 = b3;
  s2.p3 = &b3[1];
  s3.p2 = b3[1];
  s4.p2 = &b3[1][2];
  s5.p1 = b3[1][2];
  s6.p1 = &b3[1][2][3];

  s1.pp[0] = b1;
  s2.pp[0] = &b1[1];
  s3.pp[0] = b2[1];
  s4.pp[0] = &b2[1][2];
  s5.pp[0] = b3[1][2];
  s6.pp[0] = &b3[1][2][3];
}

void test_escape_through_arrays() {
  escape_through_arrays();
  int x1 = *s1.p1; // BAD
  int x2 = *s2.p1; // BAD

  int* x3 = s1.p2[1]; // BAD
  int x4 = *s1.p2[1]; // BAD
  int* x5 = *s2.p2; // BAD
  int* x6 = s3.p1; // BAD
  int x7 = *&s4.p1[1]; // BAD

  int x8 = *s1.p3[1][2]; // BAD
  int x9 = (*s2.p3[0])[0]; // BAD
  int x10 = **s3.p2; // BAD
  int x11 = **s4.p2; // BAD
  int x12 = (*s4.p1); // BAD
  int x13 = s5.p1[1]; // BAD

  int* x14 = s1.pp[0]; // BAD
  int x15 = *s2.pp[0]; // BAD
  int x16 = *s3.pp[0]; // BAD
  int x17 = **s4.pp; // BAD
  int x18 = s5.pp[0][0]; // BAD
  int x19 = (*s6.pp)[0]; // BAD
}

void not_escape_through_arrays() {
  int x;

  s1.a1[0] = x;
  s1.a2[0][1] = s1.a1[0];
  **s1.a3[0] = 42;
}

void test_not_escape_through_array() {
  not_escape_through_arrays();
  
  int x20 = s1.a1[0]; // GOOD
  int x21 = s1.a2[0][1]; // GOOD
  int* x22 = s1.a3[5][2]; // GOOD
}

int maybe_deref_p(bool b) {
  if(b) {
    return *s101.p; // GOOD
  } else {
    return 0;
  }
}

int field_indirect_maybe_bad(bool b) {
  escape1();
  return maybe_deref_p(b);
}