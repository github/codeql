public class A {
  record Pair(Object x, Object y) { }

  Object source() { return null; }

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
}
