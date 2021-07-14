void sink(void *o);
void *user_input(void);

namespace qualifiers {

  struct Inner {
    void *a;

    void setA(void *value) { this->a = value; }
  };

  void pointerSetA(Inner *inner, void *value) { inner->a = value; }
  void referenceSetA(Inner &inner, void *value) { inner.a = value; }

  struct Outer {
    Inner *inner;

    Inner *getInner() { return inner; }
  };

  void assignToGetter(Outer outer) {
    outer.getInner()->a = user_input();
    sink(outer.inner->a); // $ ast MISSING: ir
  }

  void getterArgument1(Outer outer) {
    outer.getInner()->setA(user_input());
    sink(outer.inner->a); // $ ast MISSING: ir
  }

  void getterArgument2(Outer outer) {
    pointerSetA(outer.getInner(), user_input());
    sink(outer.inner->a); // $ ast MISSING: ir
  }

  void getterArgument2Ref(Outer outer) {
    referenceSetA(*outer.getInner(), user_input());
    sink(outer.inner->a); // $ ast MISSING: ir
  }

  void assignToGetterStar(Outer outer) {
    (*outer.getInner()).a = user_input();
    sink(outer.inner->a); // $ ast MISSING: ir
  }

  void assignToGetterAmp(Outer outer) {
    (&outer)->getInner()->a = user_input();
    sink(outer.inner->a); // $ ast MISSING: ir
  }
}