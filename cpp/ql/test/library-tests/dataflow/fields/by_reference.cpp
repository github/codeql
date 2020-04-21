void sink(void *o);
void *user_input(void);

struct S {
  void *a;

  /*
   * Setters
   */

  friend void nonMemberSetA(struct S *s, void *value) {
    s->a = value;
  }

  void setDirectly(void *value) {
    this->a = value;
  }

  void setIndirectly(void *value) {
    this->setDirectly(value);
  }

  void setThroughNonMember(void *value) {
    nonMemberSetA(this, value);
  }

  /*
   * Getters
   */

  friend void *nonMemberGetA(const struct S *s) {
    return s->a;
  }

  void* getDirectly() const {
    return this->a;
  }

  void* getIndirectly() const {
    return this->getDirectly();
  }

  void *getThroughNonMember() const {
    return nonMemberGetA(this);
  }
};

void test_setDirectly() {
  S s;
  s.setDirectly(user_input());
  sink(s.getDirectly()); // flow
}

void test_setIndirectly() {
  S s;
  s.setIndirectly(user_input());
  sink(s.getIndirectly()); // flow
}

void test_setThroughNonMember() {
  S s;
  s.setThroughNonMember(user_input());
  sink(s.getThroughNonMember()); // flow
}

void test_nonMemberSetA() {
  S s;
  nonMemberSetA(&s, user_input());
  sink(nonMemberGetA(&s)); // flow
}

////////////////////

struct Inner {
  void *a;
};

struct Outer {
  Inner inner_nested, *inner_ptr;
  void *a;
};

void taint_inner_a_ptr(Inner *inner) {
  inner->a = user_input();
}

void taint_inner_a_ref(Inner &inner) {
  inner.a = user_input();
}

void taint_a_ptr(void **pa) {
  *pa = user_input();
}

void taint_a_ref(void *&pa) {
  pa = user_input();
}

void test_outer_with_ptr(Outer *pouter) {
  Outer outer;

  taint_inner_a_ptr(&outer.inner_nested);
  taint_inner_a_ptr(outer.inner_ptr);
  taint_a_ptr(&outer.a);

  taint_inner_a_ptr(&pouter->inner_nested);
  taint_inner_a_ptr(pouter->inner_ptr);
  taint_a_ptr(&pouter->a);

  sink(outer.inner_nested.a); // flow
  sink(outer.inner_ptr->a); // flow [NOT DETECTED by IR]
  sink(outer.a); // flow [NOT DETECTED]

  sink(pouter->inner_nested.a); // flow
  sink(pouter->inner_ptr->a); // flow [NOT DETECTED by IR]
  sink(pouter->a); // flow [NOT DETECTED]
}

void test_outer_with_ref(Outer *pouter) {
  Outer outer;

  taint_inner_a_ref(outer.inner_nested);
  taint_inner_a_ref(*outer.inner_ptr);
  taint_a_ref(outer.a);

  taint_inner_a_ref(pouter->inner_nested);
  taint_inner_a_ref(*pouter->inner_ptr);
  taint_a_ref(pouter->a);

  sink(outer.inner_nested.a); // flow
  sink(outer.inner_ptr->a); // flow [NOT DETECTED by IR]
  sink(outer.a); // flow [NOT DETECTED by IR]

  sink(pouter->inner_nested.a); // flow
  sink(pouter->inner_ptr->a); // flow [NOT DETECTED by IR]
  sink(pouter->a); // flow [NOT DETECTED by IR]
}
