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
  sink(s.getThroughNonMember()); // flow [NOT DETECTED]
}

void test_nonMemberSetA() {
  S s;
  nonMemberSetA(&s, user_input());
  sink(nonMemberGetA(&s)); // flow [NOT DETECTED due to lack of flow through &]
}
