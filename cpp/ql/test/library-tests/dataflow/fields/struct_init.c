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
  sink(ab->a); // flow x3 [NOT DETECTED]
  sink(ab->b); // no flow
}

int struct_init(void) {
  struct AB ab = { user_input(), 0 };

  sink(ab.a); // flow [NOT DETECTED]
  sink(ab.b); // no flow
  absink(&ab);

  struct Outer outer = {
    { user_input(), 0 },
    &ab,
  };

  sink(outer.nestedAB.a); // flow [NOT DETECTED]
  sink(outer.nestedAB.b); // no flow
  sink(outer.pointerAB->a); // flow [NOT DETECTED]
  sink(outer.pointerAB->b); // no flow

  absink(&outer.nestedAB);
  absink(outer.pointerAB);
}
