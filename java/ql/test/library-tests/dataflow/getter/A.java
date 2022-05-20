public class A {
  int foo;

  int getFoo() {
    return this.foo;
  }

  void setFoo(int x) {
    this.foo = x;
  }

  static A withFoo(int x) {
    A a = new A();
    a.foo = x;
    return a;
  }

  static void run() {
    A a = new A();
    a.setFoo(1);
    int x = a.getFoo();
    A a2 = withFoo(2);
    x = a.aGetter();
    x = a2.notAGetter();
  }

  static class C1 {
    A maybeId(A a) {
      return a;
    }
  }

  static class C2 extends C1 {
    @Override
    A maybeId(A a) {
      return new A();
    }
  }

  static A maybeIdWrap(A a, C1 c) {
    return c.maybeId(a);
  }

  int aGetter() {
    return maybeIdWrap(this, new C1()).foo;
  }

  int notAGetter() {
    return maybeIdWrap(this, new C2()).foo;
  }
}
