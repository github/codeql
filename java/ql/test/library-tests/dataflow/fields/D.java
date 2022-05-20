public class D {
  Box2 boxfield;

  public void f1() {
    Elem e = new Elem();
    Box2 b = new Box2(new Box1(null));
    b.box.elem = e;
    sinkWrap(b);
  }

  public void f2() {
    Elem e = new Elem();
    Box2 b = new Box2(new Box1(null));
    b.box.setElem(e);
    sinkWrap(b);
  }

  public void f3() {
    Elem e = new Elem();
    Box2 b = new Box2(new Box1(null));
    b.getBox1().elem = e;
    sinkWrap(b);
  }

  public void f4() {
    Elem e = new Elem();
    Box2 b = new Box2(new Box1(null));
    b.getBox1().setElem(e);
    sinkWrap(b);
  }

  public static void sinkWrap(Box2 b2) {
    sink(b2.getBox1().getElem());
  }

  public void f5a() {
    Elem e = new Elem();
    boxfield = new Box2(new Box1(null));
    boxfield.box.elem = e;
    f5b();
  }

  private void f5b() {
    sink(boxfield.box.elem);
  }

  public static void sink(Object o) { }

  public static class Elem { }

  public static class Box1 {
    public Elem elem;
    public Box1(Elem e) { elem = e; }
    public Elem getElem() { return elem; }
    public void setElem(Elem e) { elem = e; }
  }

  public static class Box2 {
    public Box1 box;
    public Box2(Box1 b) { box = b; }
    public Box1 getBox1() { return box; }
    public void setBox1(Box1 b) { box = b; }
  }
}
