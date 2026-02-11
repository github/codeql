public class A {
  Object source() { return null; }
  void sink(Object o) { }

  boolean isSafe(Object o) { return o == null; }

  void assertSafe(Object o) { if (o != null) throw new RuntimeException(); }

  private boolean wrapIsSafe(Object o) { return isSafe(o); }

  private void wrapAssertSafe(Object o) { assertSafe(o); }

  void test1() {
    Object x = source();
    if (!isSafe(x)) {
      x = null;
    }
    sink(x);

    x = source();
    if (!isSafe(x)) {
      if (isSafe(x)) {
        sink(x);
      } else {
        throw new RuntimeException();
      }
    }
    sink(x);
  }

  void test2() {
    Object x = source();
    assertSafe(x);
    sink(x);
  }

  void test3() {
    Object x = source();
    if (wrapIsSafe(x)) {
      sink(x);
    }
  }

  void test4() {
    Object x = source();
    wrapAssertSafe(x);
    sink(x);
  }
}
