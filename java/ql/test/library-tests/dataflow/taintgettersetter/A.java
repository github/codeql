public class A {
  String taint() { return "tainted"; }
  void sink(Object o) { }

  static String step(String s) { return s + "0"; }

  static class Box {
    String s;
    Box(String s) {
      this.s = s + "1";
    }
    String getS1() { return s + "2"; }
    String getS2() { return step(s + "_") + "2"; }
    void setS1(String s) { this.s = "3" + s; }
    void setS2(String s) { this.s = "3" + step("_" + s); }
    static Box mk(String s) {
      Box b = new Box("");
      b.s = step(s);
      return b;
    }
  }

  void foo(Box b1, Box b2) {
    b1.setS1(taint());
    sink(b1.getS1());

    b2.setS2(taint());
    sink(b2.getS2());

    String t3 = taint();
    Box b3 = new Box(step(t3));
    sink(b3.s);

    Box b4 = Box.mk(taint());
    sink(b4.getS1());
  }

  static class Box2 {
    String s;
    String getS() { return s; }
    void setS(String s) { this.s = s; }

    Box2(String s) {
      setS(s + "1");
    }
    String getS1() { return getS() + "2"; }
    String getS2() { return step(getS() + "_") + "2"; }
    void setS1(String s) { setS("3" + s); }
    void setS2(String s) { setS("3" + step("_" + s)); }
    static Box2 mk(String s) {
      Box2 b = new Box2("");
      b.setS(step(s));
      return b;
    }
  }

  void foo2(Box2 b1, Box2 b2) {
    b1.setS1(taint());
    sink(b1.getS1());

    b2.setS2(taint());
    sink(b2.getS2());

    String t3 = taint();
    Box2 b3 = new Box2(step(t3));
    sink(b3.s);

    Box2 b4 = Box2.mk(taint());
    sink(b4.getS1());
  }
}
