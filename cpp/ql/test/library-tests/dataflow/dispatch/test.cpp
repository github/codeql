struct Base {
  void f();
  virtual void virtual_f();
};

struct Derived : Base {
  void f();
  void virtual_f();
};

void test_simple() {
  Base b;
  b.f(); // $ target=2
  b.virtual_f(); // $ target=3

  Derived d;
  d.f(); // $ target=7
  d.virtual_f(); // $ target=8

  Base* b_ptr = &d;
  b_ptr->f(); // $ target=2
  b_ptr->virtual_f(); // $ target=8

  Base& b_ref = d;
  b_ref.f(); // $ target=2
  b_ref.virtual_f(); // $ target=8

  Base* b_null = nullptr;
  b_null->f(); // $ target=2
  b_null->virtual_f(); // $ target=3

  Base* base_is_derived = new Derived();
  base_is_derived->f(); // $ target=2
  base_is_derived->virtual_f(); // $ target=8

  Base* base_is_base = new Base();
  base_is_base->f(); // $ target=2
  base_is_base->virtual_f(); // $ target=3

  Derived* derived_is_derived = new Derived();
  derived_is_derived->f(); // $ target=7
  derived_is_derived->virtual_f(); // $ target=8

  Base& b_ref2 = b;
  b_ref2 = d;
  b_ref2.f(); // $ target=2
  b_ref2.virtual_f(); // $ target=3
}

struct S {
  Base* b1;
  Base* b2;
};

void test_fields() {
  S s;

  s.b1 = new Base();
  s.b2 = new Derived();

  s.b1->virtual_f(); // $ target=3
  s.b2->virtual_f(); // $ target=8

  s.b1 = new Derived();
  s.b2 = new Base();
  s.b1->virtual_f(); // $ target=8 SPURIOUS: target=3 // type-tracking has no 'clearsContent' feature and C/C++ doesn't have field-based SSA
  s.b2->virtual_f(); // $ target=3 SPURIOUS: target=8 // type-tracking has no 'clearsContent' feature and C/C++ doesn't have field-based SSA
}

Base* getDerived() {
  return new Derived();
}

void test_getDerived() {
  Base* b = getDerived();
  b->virtual_f(); // $ target=8

  Derived d = *(Derived*)getDerived();
  d.virtual_f(); // $ target=8
}

void write_to_arg(Base* b) {
  *b = Derived();
}

void write_to_arg_2(Base** b) {
	Derived* d = new Derived();
  *b = d;
}

void test_write_to_arg() {
  {
    Base b;
    write_to_arg(&b);
    b.virtual_f(); // $ SPURIOUS: target=3 MISSING: target=8 // missing flow through the copy-constructor in write_to_arg
  }

  {
    Base* b;
    write_to_arg_2(&b);
    b->virtual_f(); // $ target=8
  }
}

Base* global_derived;

void set_global_to_derived() {
  global_derived = new Derived();
}

void read_global() {
  global_derived->virtual_f(); // $ target=8
}

Base* global_base_or_derived;

void set_global_base_or_derived_1() {
  global_base_or_derived = new Base();
}

void set_global_base_or_derived_2() {
  global_base_or_derived = new Derived();
}

void read_global_base_or_derived() {
  global_base_or_derived->virtual_f(); // $ target=3 target=8
}