public class A {
  private int i;
  private int j;

  public A() {
    this(1);
  }

  public A(int i) {
    super();
    this.i = i;
    j = i;
  }

  public A getThis() {
    return this;
  }

  public A getThisWrap() {
    Object o = j;
    return getThis();
  }

  public static void f() {
    A a = new A();
    A a2 = a.getThis().getThisWrap();
    C c = new C();
    c.set();
  }

  public static class B {
    public int bx;
  }

  public static class C extends B {
    public void set() {
      C.this.bx = 1;
      super.bx = 1;
      C.super.bx = 1;
    }
  }
}
