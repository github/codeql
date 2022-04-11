void argument_source_0(...);
void argument_source_1(...);
void argument_source_2(...);
void sink(...);

void test_0(int*** p0, int**** p1, int**** p2, int**** p3, int**** p4) {
  argument_source_0(&p0);
  sink(p0); // $ ir ast
  sink(*p0);
  sink(**p0);
  sink(***p0);

  argument_source_0(p1);
  sink(p1); // $ SPURIOUS: ast
  sink(*p1); // $ ir MISSING: ast
  sink(**p1);
  sink(***p1);
  sink(****p1);

  argument_source_0(*p2);
  sink(p2);
  sink(*p2);
  sink(**p2); // $ ir MISSING: ast
  sink(***p2);
  sink(****p2);

  argument_source_0(**p3);
  sink(p3);
  sink(*p3);
  sink(**p3);
  sink(***p3); // $ ir MISSING: ast
  sink(****p3);

  argument_source_0(***p4);
  sink(p4);
  sink(*p4);
  sink(**p4);
  sink(***p4);
  sink(****p4); // $ ir MISSING: ast
}

void test_1(int*** p0, int**** p1, int**** p2, int**** p3, int**** p4) {
  argument_source_1(&p0);
  sink(p0); // $ SPURIOUS: ast
  sink(*p0); // $ ir
  sink(**p0);
  sink(***p0);

  argument_source_1(p1);
  sink(p1); // $ SPURIOUS: ast
  sink(*p1);
  sink(**p1); // $ ir MISSING: ast
  sink(***p1);
  sink(****p1);

  argument_source_1(*p2);
  sink(p2);
  sink(*p2);
  sink(**p2);
  sink(***p2); // $ ir MISSING: ast
  sink(****p2);

  argument_source_1(**p3);
  sink(p3);
  sink(*p3);
  sink(**p3);
  sink(***p3);
  sink(****p3); // $ ir MISSING: ast

  argument_source_1(***p4);
  sink(p4);
  sink(*p4);
  sink(**p4);
  sink(***p4);
  sink(****p4);
}

void test_2(int*** p0, int**** p1, int**** p2, int**** p3, int**** p4) {
  argument_source_2(&p0);
  sink(p0); // $ SPURIOUS: ast
  sink(*p0);
  sink(**p0); // $ ir
  sink(***p0);

  argument_source_2(p1);
  sink(p1); // $ SPURIOUS: ast
  sink(*p1);
  sink(**p1);
  sink(***p1);// $ ir MISSING: ast
  sink(****p1);

  argument_source_2(*p2);
  sink(p2);
  sink(*p2);
  sink(**p2);
  sink(***p2);
  sink(****p2); // $ ir MISSING: ast

  argument_source_2(**p3);
  sink(p3);
  sink(*p3);
  sink(**p3);
  sink(***p3);
  sink(****p3);

  argument_source_1(***p4);
  sink(p4);
  sink(*p4);
  sink(**p4);
  sink(***p4);
  sink(****p4);
}

struct S {
  int*** p0;
  int**** p1;
  int**** p2;
  int**** p3;
  int**** p4;
};

void test_0_with_fields(S* s) {
  argument_source_0(&s->p0);
  sink(s->p0); // $ ir ast
  sink(*s->p0);
  sink(**s->p0);
  sink(***s->p0);

  argument_source_0(s->p1);
  sink(s->p1); // $ SPURIOUS: ast
  sink(*s->p1); // $ ir MISSING: ast
  sink(**s->p1);
  sink(***s->p1);
  sink(****s->p1);

  argument_source_0(*s->p2);
  sink(s->p2);
  sink(*s->p2);
  sink(**s->p2); // $ ir MISSING: ast
  sink(***s->p2);
  sink(****s->p2);

  argument_source_0(**s->p3);
  sink(s->p3);
  sink(*s->p3);
  sink(**s->p3);
  sink(***s->p3); // $ ir MISSING: ast
  sink(****s->p3);

  argument_source_0(***s->p4);
  sink(s->p4);
  sink(*s->p4);
  sink(**s->p4);
  sink(***s->p4);
  sink(****s->p4); // $ ir MISSING: ast
}

void test_1_with_fields(S* s) {
  argument_source_1(&s->p0);
  sink(s->p0); // $ SPURIOUS: ast
  sink(*s->p0); // $ ir
  sink(**s->p0);
  sink(***s->p0);

  argument_source_1(s->p1);
  sink(s->p1); // $ SPURIOUS: ast
  sink(*s->p1);
  sink(**s->p1); // $ ir MISSING: ast
  sink(***s->p1);
  sink(****s->p1);

  argument_source_1(*s->p2);
  sink(s->p2);
  sink(*s->p2);
  sink(**s->p2);
  sink(***s->p2); // $ ir MISSING: ast
  sink(****s->p2);

  argument_source_1(**s->p3);
  sink(s->p3);
  sink(*s->p3);
  sink(**s->p3);
  sink(***s->p3);
  sink(****s->p3); // $ ir MISSING: ast

  argument_source_1(***s->p4);
  sink(s->p4);
  sink(*s->p4);
  sink(**s->p4);
  sink(***s->p4);
  sink(****s->p4);
}

void test_2_with_fields(S* s) {
  argument_source_2(&s->p0);
  sink(s->p0); // $ SPURIOUS: ast
  sink(*s->p0);
  sink(**s->p0); // $ ir
  sink(***s->p0);

  argument_source_2(s->p1);
  sink(s->p1); // $ SPURIOUS: ast
  sink(*s->p1);
  sink(**s->p1);
  sink(***s->p1);// $ ir MISSING: ast
  sink(****s->p1);

  argument_source_2(*s->p2);
  sink(s->p2);
  sink(*s->p2);
  sink(**s->p2);
  sink(***s->p2);
  sink(****s->p2); // $ ir MISSING: ast

  argument_source_2(**s->p3);
  sink(s->p3);
  sink(*s->p3);
  sink(**s->p3);
  sink(***s->p3);
  sink(****s->p3);

  argument_source_1(***s->p4);
  sink(s->p4);
  sink(*s->p4);
  sink(**s->p4);
  sink(***s->p4);
  sink(****s->p4);
}