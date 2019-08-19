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

  sink(s1.m1); // flow
  sink(s2.m1); // flow
  sink(s3.m1); // no flow
}

void assignAfterAlias() {
  S s1 = { 0, 0 };
  S &ref1 = s1;
  ref1.m1 = user_input();
  sink(s1.m1); // flow [NOT DETECTED]

  S s2 = { 0, 0 };
  S &ref2 = s2;
  s2.m1 = user_input();
  sink(ref2.m1); // flow [NOT DETECTED]
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
  sink(copy2.m1); // flow
}
