public class A {
  void sink(Object o) { }

  void foo() {
    Object src = null;
    Object x = src;
    sink(x);
  }
}
