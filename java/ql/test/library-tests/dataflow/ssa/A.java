public class A {
  Object source() { return null; }
  void sink(Object o) { }

  boolean isSafe(Object o) { return o == null; }

  void foo() {
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
}
