public class A {
  static void sink(Object o) { }

  static class Box {
    public Object elem;
  }

  static Object src() { return new Object(); }

  Box f1() {
    Box b = new Box();
    b.elem = src();
    return b;
  }

  void f2() {
    Box b = f1();
    f3(b);
  }

  void f3(Box b) {
    Box other = new Box();
    addElem(other);
    sink(other.elem);
  }

  void addElem(Box b) {
    b.elem = new Object();
  }
}
