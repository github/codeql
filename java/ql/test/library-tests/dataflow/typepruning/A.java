public class A {
  Object customStep(Object o) { return null; }

  Object source() { return null; }

  void sink(Object o) { }

  Object through1(Object o) {
    Object o2 = customStep(o);
    String s = (String)o2;
    return s;
  }

  void foo() {
    Object x = through1(source());
    sink(x);
  }
}
