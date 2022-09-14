public class ViableCallable4 {
  static class Sup {
    void f() { }
  }
  static class A1 extends Sup {
    @Override void f() { }
  }
  static class A2 extends Sup {
    @Override void f() { }
  }
  static class A3 extends Sup {
    @Override void f() { }
  }

  void foo(Sup s, boolean b) {
    s.f();
    if (s instanceof A1 || s instanceof A2) {
      s.f();
    }
    Sup s2 = b ? new A3() : new Sup();
    s2.f();
  }
}
