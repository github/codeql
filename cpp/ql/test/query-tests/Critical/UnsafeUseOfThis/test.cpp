struct A { virtual void f() = 0; };

struct B;
void call_f(B*);

struct B : public A {
  B() { // $ Source[cpp/unsafe-use-of-this]=r4
    call_f(this);
  }

  B(B& b) {
    b.f(); // $ Alert[cpp/unsafe-use-of-this]=r1 // BAD: undefined behavior
  }

  ~B() { // $ Source[cpp/unsafe-use-of-this]=r2
    f(); // $ Alert[cpp/unsafe-use-of-this]=r2 // BAD: undefined behavior
  }
};

struct C : public B {
  C(bool b) { // $ Source[cpp/unsafe-use-of-this]=r3
    call_f(this);

    if(b) {
      this->f(); // $ Alert[cpp/unsafe-use-of-this]=r3 // BAD: undefined behavior
    }
  }
};

struct D : public B {
  D() : B(*this) {} // $ Source[cpp/unsafe-use-of-this]=r1
};

void call_f(B* x) {
  x->f(); // $ Alert[cpp/unsafe-use-of-this]=r3 Alert[cpp/unsafe-use-of-this]=r4 // 2 x BAD: Undefined behavior
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
