int user_input();
void sink(int);

struct S {
  int m1, m2;
};

void pointerSetter(S *s) {
  s->m1 = user_input();
}

void referenceSetter(S &s) {
  s.m1 = user_input();
}

void copySetter(S s) {
  s.m1 = user_input();
}

void callSetters() {
  S s1 = { 0, 0 };
  S s2 = { 0, 0 };
  S s3 = { 0, 0 };

  pointerSetter(&s1);
  referenceSetter(s2);
  copySetter(s3);

  sink(s1.m1); // $ast,ir
  sink(s2.m1); // $ast,ir
  sink(s3.m1); // no flow
}

void assignAfterAlias() {
  S s1 = { 0, 0 };
  S &ref1 = s1;
  ref1.m1 = user_input();
  sink(s1.m1); // $f-:ast $ir

  S s2 = { 0, 0 };
  S &ref2 = s2;
  s2.m1 = user_input();
  sink(ref2.m1); // $f-:ast $ir
}

void assignAfterCopy() {
  S s1 = { 0, 0 };
  S copy1 = s1;
  copy1.m1 = user_input();
  sink(s1.m1); // no flow

  S s2 = { 0, 0 };
  S copy2 = s2;
  s2.m1 = user_input();
  sink(copy2.m1); // no flow
}

void assignBeforeCopy() {
  S s2 = { 0, 0 };
  s2.m1 = user_input();
  S copy2 = s2;
  sink(copy2.m1); // $ast,ir
}

struct Wrapper {
  S s;
};

void copyIntermediate() {
  Wrapper w = { { 0, 0 } };
  S s = w.s;
  s.m1 = user_input();
  sink(w.s.m1); // no flow
}

void pointerIntermediate() {
  Wrapper w = { { 0, 0 } };
  S *s = &w.s;
  s->m1 = user_input();
  sink(w.s.m1); // $f-:ast $ir
}

void referenceIntermediate() {
  Wrapper w = { { 0, 0 } };
  S &s = w.s;
  s.m1 = user_input();
  sink(w.s.m1); // $f-:ast $ir
}

void nestedAssign() {
  Wrapper w = { { 0, 0 } };
  w.s.m1 = user_input();
  sink(w.s.m1); // $ast,ir
}

void addressOfField() {
  S s;
  s.m1 = user_input();

  S s_copy = s;
  int* px = &s_copy.m1;
  sink(*px); // $f-:ast,ir
}