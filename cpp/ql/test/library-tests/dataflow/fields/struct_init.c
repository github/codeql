void sink(void *o);
void *user_input(void);

struct AB {
  void *a;
  void *b;
};

struct Outer {
  struct AB nestedAB;
  struct AB *pointerAB;
};

void absink(struct AB *ab) {
  sink(ab->a); //$ ast,ir=20:20 ast,ir=27:7 ast,ir=40:20
  sink(ab->b); // no flow
}

int struct_init(void) {
  struct AB ab = { user_input(), 0 };

  sink(ab.a); //$ ast,ir
  sink(ab.b); // no flow
  absink(&ab);

  struct Outer outer = {
    { user_input(), 0 },
    &ab,
  };

  sink(outer.nestedAB.a); //$ ast,ir
  sink(outer.nestedAB.b); // no flow
  sink(outer.pointerAB->a); //$ ast,ir
  sink(outer.pointerAB->b); // no flow

  absink(&outer.nestedAB);
}

int struct_init2(void) {
  struct AB ab = { user_input(), 0 };
  struct Outer outer = {
    { user_input(), 0 },
    &ab,
  };

  absink(outer.pointerAB);
}
