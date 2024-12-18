public class Test {

  interface I { String get(); }
  static class A implements I { public String afield; public A(String a) { this.afield = a; } public String get() { return afield; } }
  static class B implements I { public String bfield; public B(String b) { this.bfield = b; } public String get() { return bfield; } }

  public static String sink(String s) { return s; }

  public static void test(boolean inp) {

    I i = inp ? new A("A") : new B("B");

    switch(i) {
      case A a:
        sink(a.get());
        break;
      case B b:
        sink(b.get());
        break;
      default:
        break;
    }

    switch(i) {
      case A a -> sink(a.get());
      case B b -> sink(b.get());
      default -> { }
    }

    var x = switch(i) {
      case A a:
        yield sink(a.get());
      case B b:
        yield sink(b.get());
      default:
        yield "Default case";
    };

    var y = switch(i) {
      case A a -> sink(a.get());
      case B b -> sink(b.get());
      default -> "Default case";
    };

  }

}
