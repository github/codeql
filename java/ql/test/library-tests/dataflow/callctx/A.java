public class A {
  static void sink(Object x) { }

  static Object source() { return null; }

  static class C1 {
    C1() { }

    C1(Object x) {
      foo(x);
    }

    void wrapFoo1(Object x) {
      foo(x);
    }

    void wrapFoo2(Object x) {
      this.foo(x);
    }

    void foo(Object x) {
      Object c1 = x;
      sink(c1);
    }
  }

  static class C2 extends C1 {
    C2() { }

    C2(Object x) {
      super(x);
    }

    void foo(Object x) {
      Object c2 = x;
      sink(c2);
    }

    void callWrapFoo2() {
      wrapFoo2(source());
    }
  }

  static void wrapFoo3(C1 c1, Object x) {
    c1.foo(x);
  }

  void test(C1 c) {
    c.wrapFoo1(source());
    c.wrapFoo2(source());
    wrapFoo3(c, source());

    new C1(source());
    new C1().wrapFoo1(source());
    new C1().wrapFoo2(source());
    wrapFoo3(new C1(), source());

    new C2(source());
    new C2().wrapFoo1(source());
    new C2().wrapFoo2(source());
    wrapFoo3(new C2(), source());
  }
}
