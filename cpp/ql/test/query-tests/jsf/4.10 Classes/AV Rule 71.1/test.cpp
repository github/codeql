class Base {
public:
  Base() {
    init(); // $ Alert
    this->init(); // $ Alert
    (*this).init(); // $ Alert
    helper(); // $ Alert (indirectly calls a virtual function)
    Base::init(); // GOOD: explicitly qualified, so statically bound
    notOverridden(); // GOOD: not overridden in any derived class
    nonVirtual(); // GOOD: not virtual
  }

  ~Base() {
    cleanup(); // $ Alert
    Base::cleanup(); // GOOD: explicitly qualified
  }

  virtual void init() {}
  virtual void cleanup() {}
  virtual void notOverridden() {}
  void nonVirtual() {}

  void helper() {
    init();
  }

  void other() {
    init(); // GOOD: not in a constructor or destructor
  }
};

class Derived : public Base {
public:
  Derived() {
    init(); // GOOD: not overridden in a class derived from Derived
  }

  void init() override {}
  void cleanup() override {}
};

class Unrelated {
public:
  Unrelated(Base &b) {
    b.init(); // GOOD: not a call on `this`
  }
};
