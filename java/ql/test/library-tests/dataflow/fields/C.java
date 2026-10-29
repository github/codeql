public class C {

  private Elem s1 = new Elem();
  private final Elem s2 = new Elem();
  private Elem s3;
  private static Elem s4 = new Elem();

  public static void main(String[] args){
    C c = new C();
    c.func();
  }

  private C() {
    this.s3 = new Elem();
  }

  public void func(){
    sink(s1);
    sink(s2);
    sink(s3);
    sink(s4);
  }

  public static void sink(Object o) { }

  public static class Elem { }
}
