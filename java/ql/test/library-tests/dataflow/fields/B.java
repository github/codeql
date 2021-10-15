public class B {

  public void f1() {
    Elem e = new Elem();
    Box1 b1 = new Box1(e, null);
    Box2 b2 = new Box2(b1);
    sink(b2.box1.elem1); // flow
    sink(b2.box1.elem2); // no flow
  }

  public void f2() {
    Elem e = new Elem();
    Box1 b1 = new Box1(null, e);
    Box2 b2 = new Box2(b1);
    sink(b2.box1.elem1); // no flow
    sink(b2.box1.elem2); // flow
  }

  public static void sink(Object o) { }

  public static class Elem { }

  public static class Box1 {
    public Elem elem1;
    public Elem elem2;
    public Box1(Elem e1, Elem e2) {
      this.elem1 = e1;
      this.elem2 = e2;
    }
  }

  public static class Box2 {
    public Box1 box1;
    public Box2(Box1 b1) {
      this.box1 = b1;
    }
  }
}
