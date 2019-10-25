public class Test {
  static class A {
    B step() { return null; }
  }
  static class B extends C { }
  static class C { }

  A src() { return new A(); }

  void sink(Object o) { }

  void flow() {
    A a = src();
    C c = m1(a);
    sink(c);
  }

  C m1(A a) {
    return a.step();
  }
}

