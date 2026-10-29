public class A {
  static void sink(Object x) { }

  static Object source(String srctag) { return null; }

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
      sink(c1); // $ hasValueFlow=c.1 hasValueFlow=c.2 hasValueFlow=c.3 hasValueFlow=C1 hasValueFlow=C1.1 hasValueFlow=C1.2 hasValueFlow=C1.3
    }
  }

  static class C2 extends C1 {
    C2() { }

    C2(Object x) {
      super(x);
    }

    void foo(Object x) {
      Object c2 = x;
      sink(c2); // $ hasValueFlow=2 hasValueFlow=c.1 hasValueFlow=c.2 hasValueFlow=c.3 hasValueFlow=C2 hasValueFlow=C2.1 hasValueFlow=C2.2 hasValueFlow=C2.3
    }

    void callWrapFoo2() {
      wrapFoo2(source("2"));
    }
  }

  static void wrapFoo3(C1 c1, Object x) {
    c1.foo(x);
  }

  void test(C1 c) {
    c.wrapFoo1(source("c.1"));
    c.wrapFoo2(source("c.2"));
    wrapFoo3(c, source("c.3"));

    new C1(source("C1"));
    new C1().wrapFoo1(source("C1.1"));
    new C1().wrapFoo2(source("C1.2"));
    wrapFoo3(new C1(), source("C1.3"));

    new C2(source("C2"));
    new C2().wrapFoo1(source("C2.1"));
    new C2().wrapFoo2(source("C2.2"));
    wrapFoo3(new C2(), source("C2.3"));
  }

  static class Sup {
    void wrap(Object x) {
      tgt(x);
    }

    void tgt(Object x) {
      sink(x); // $ hasValueFlow=s
    }
  }

  static class A1 extends Sup {
    void tgt(Object x) {
      sink(x); // $ hasValueFlow=s hasValueFlow=s12
    }
  }

  static class A2 extends Sup {
    void tgt(Object x) {
      sink(x); // $ hasValueFlow=s hasValueFlow=s12
    }
  }

  static class A3 extends Sup {
    void tgt(Object x) {
      sink(x); // $ hasValueFlow=s
    }
  }

  void test2(Sup s) {
    s.wrap(source("s"));

    if (s instanceof A1 || s instanceof A2) {
      s.wrap(source("s12"));
    }
  }
}
