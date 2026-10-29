

class A {
public:
  void foo();
  int k;
};

class B {
public:
  template <typename T>
  B(T x) {
    int k = x.k;
    x.foo();
  }
};

A a;
B b(a);
