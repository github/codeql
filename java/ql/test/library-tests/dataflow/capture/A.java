public class A {
  static class Box {
    String elem;
    Box(String e) { elem = e; }
    void setElem(String e) { elem = e; }
    String getElem() { return elem; }
  }

  String get() {
    return null;
  }

  void f1(int i) {
    A a = f2("A", i);
    String x = a.get();
  }

  A f2(String p, int i) {
    String s;
    if (i == 0) {
      s = "B";
    } else {
      s = "C";
    }
    Box b1 = new Box("D");
    Box b2 = new Box(null);
    b2.setElem("E");
    A a = new A() {
      @Override
      String get() {
        switch (i) {
          case 0: return p;
          case 1: return s;
          case 2: return b1.getElem();
          case 3: return b2.getElem();
        }
      }
    };
    return a;
  }
}
