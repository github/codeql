
int global;

class C {
  int x;

public:

  void f1() {
    // Implicit dereference of `this.`
    x++;
  }

  void f2() {
    // Explicit dereference of `this.`
    this->x++;
  }

  int f3() const {
    // We expect the type of `this` to be const-qualified.
    return x;
  }

  int f4() volatile {
    // We expect the type of `this` to be volatile-qualified.
    return x;
  }

  int f5() const volatile {
    // We expect the type of `this` to be qualified as both const and volatile.
    return x;
  }

  void f6() {
    // No use of `this`, but we still expect to be able to get its type.
    global++;
  }

  float f7() const & {
    // We expect the type of `this` to be const-qualified.
    return x;
  }

  float f8() && {
    // We expect the type of `this` to be unqualified.
    return x;
  }
};

// We want to test that D* is in the database even when there's no use of it,
// not even through an implicit dereference of `this`.
class D {
  void f() {
    global++;
  }
};

template<typename T>
class InstantiatedTemplateClass {
  int x;

public:

  void f1() {
    // Implicit dereference of `this.`
    x++;
  }

  void f2() {
    // Explicit dereference of `this.`
    this->x++;
  }

  int f3() const {
    // We expect the type of `this` to be const-qualified.
    return x;
  }

  int f4() volatile {
    // We expect the type of `this` to be volatile-qualified.
    return x;
  }

  int f5() const volatile {
    // We expect the type of `this` to be qualified as both const and volatile.
    return x;
  }

  void f6() {
    // No use of `this`, but we still expect to be able to get its type.
    global++;
  }

  float f7() const & {
    // We expect the type of `this` to be const-qualified.
    return x;
  }

  float f8() && {
    // We expect the type of `this` to be unqualified.
    return x;
  }
};

void instantiate() {
  InstantiatedTemplateClass<int> x;
  x.f1();
  x.f2();
  x.f3();
  x.f4();
  x.f5();
  x.f6();
  x.f7();

  float val = InstantiatedTemplateClass<int>().f8();
}

// Since there are no instantiations of this class, we don't expect
// MemberFunction::getTypeOfThis() to hold.
template<typename T>
class UninstantiatedTemplateClass {
  int x;

public:

  void f1() {
    x++;
  }
};
