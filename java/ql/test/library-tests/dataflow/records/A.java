public class A {
  record Pair(Object x, Object y) { }

  static Object source() { return null; }

  void sink(Object o) { }

  void foo() {
    Pair p1 = new Pair(source(), null);
    Pair p2 = new Pair(new Object(), source());
    bar(p1, p2);
  }

  void bar(Pair p1, Pair p2) {
    sink(p1.x);
    sink(p1.y);
    sink(p2.x);
    sink(p2.y);
    Object p1x = p1.x();
    Object p1y = p1.y();
    Object p2x = p2.x();
    Object p2y = p2.y();
    sink(p1x);
    sink(p1y);
    sink(p2x);
    sink(p2y);
  }

  record RecWithGetter(Object f) {
    public Object f() {
      return this.f;
    }
  }

  record RecWithWeirdGetter1(Object f) {
    public Object f() {
      return new Object();
    }
  }

  record RecWithWeirdGetter2(Object f) {
    public Object f() {
      return source();
    }
  }

  void testExplicitGetter1() {
    RecWithGetter r1 = new RecWithGetter(source());
    RecWithWeirdGetter1 r2 = new RecWithWeirdGetter1(source());
    RecWithWeirdGetter2 r3 = new RecWithWeirdGetter2(source());
    testExplicitGetter2(r1, r2, r3);
  }

  void testExplicitGetter2(RecWithGetter r1, RecWithWeirdGetter1 r2, RecWithWeirdGetter2 r3) {
    sink(r1.f);
    sink(r2.f);
    sink(r3.f);
    Object r1f = r1.f();
    Object r2f = r2.f();
    Object r3f = r3.f();
    sink(r1f);
    sink(r2f);
    sink(r3f);
  }
}
