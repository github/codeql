public class A {

  public void f1() {
    C c = new C();
    B b = B.make(c);
    sink(b.c); // flow
  }

  public void f2() {
    B b = new B();
    b.set(new C1());
    sink(b.get()); // flow
    sink((new B(new C())).get()); // flow
  }

  public void f3() {
    B b1 = new B();
    B b2;
    b2 = setOnB(b1, new C2());
    sink(b1.c); // no flow
    sink(b2.c); // flow
  }

  public void f4() {
    B b1 = new B();
    B b2;
    b2 = setOnBWrap(b1, new C2());
    sink(b1.c); // no flow
    sink(b2.c); // flow
  }

  public B setOnBWrap(B b1, C c) {
    B b2;
    b2 = setOnB(b1, c);
    return r() ? b1 : b2;
  }

  public B setOnB(B b1, C c) {
    if (r()) {
      B b2 = new B();
      b2.set(c);
      return b2;
    }
    return b1;
  }

  public void f5() {
    A a = new A();
    C1 c1 = new C1();
    c1.a = a;
    f6(c1);
  }
  public void f6(C c) {
    if (c instanceof C1) {
      sink(((C1)c).a); // flow
    }
    C cc;
    if (c instanceof C2) {
      cc = (C2)c;
    } else {
      cc = new C1();
    }
    if (cc instanceof C1) {
      sink(((C1)cc).a); // no flow, stopped by cast to C2
    }
  }

  public void f7(B b) {
    b.set(new C());
  }
  public void f8() {
    B b = new B();
    f7(b);
    sink(b.c); // flow
  }

  public static class D {
    public B b;
    public D(B b, boolean x) {
      b.c = new C();
      this.b = x ? b : new B();
    }
  }

  public void f9() {
    B b = new B();
    D d = new D(b, r());
    sink(d.b); // flow x2
    sink(d.b.c); // flow
    sink(b.c); // flow
  }

  public void f10() {
    B b = new B();
    MyList l1 = new MyList(b, new MyList(null, null));
    MyList l2 = new MyList(null, l1);
    MyList l3 = new MyList(null, l2);
    sink(l3.head); // no flow, b is nested beneath at least one .next
    sink(l3.next.head); // flow, the precise nesting depth isn't tracked
    sink(l3.next.next.head); // flow
    sink(l3.next.next.next.head); // flow
    for (MyList l = l3; l != null; l = l.next) {
      sink(l.head); // flow
    }
  }

  public static void sink(Object o) { }
  public boolean r() { return this.hashCode() % 10 > 5; }

  public static class C { }
  public static class C1 extends C { public A a; }
  public static class C2 extends C { }

  public static class B {
    public C c;
    public B() { }
    public B(C c) {
      this.c = c;
    }
    public void set(C c) { this.c = c; }
    public C get() { return this.c; }
    public static B make(C c) {
      return new B(c);
    }
  }

  public static class MyList {
    public B head;
    public MyList next;
    public MyList(B head, MyList next) {
      this.head = head;
      this.next = next;
    }
  }
}
