struct A { virtual void f() = 0; };

struct B;
void call_f(B*);

struct B : public A {
  B() {
    call_f(this);
  }

  B(B& b) {
    b.f(); // BAD: undefined behavior
  }

  ~B() {
    f(); // BAD: undefined behavior
  }
};

struct C : public B {
  C(bool b) {
    call_f(this);

    if(b) {
      this->f(); // BAD: undefined behavior
    }
  }
};

struct D : public B {
  D() : B(*this) {}
};

void call_f(B* x) {
  x->f(); // 2 x BAD: Undefined behavior
}

struct E : public A {
  E() {
    f(); // GOOD: Will call `E::f`
  }

  void f() override {}
};

struct F : public E {
  F() {
    ((A*)this)->f(); // GOOD: Will call `E::f`
  }
};
