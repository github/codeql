public class Test {

  public static int source() { return 0; }
  public static void sink(int x) { }

  interface I { void take(int x); }
  static class C1 implements I { public void take(int x) { sink(x); } }
  static class C2 implements I { public void take(int x) { sink(x); } }

  public static void test(boolean unknown, int alsoUnknown) {

    I c1or2 = unknown ? new C1() : new C2();

    switch(c1or2) {
      case C1 c1 when alsoUnknown == 1 -> { }
      default -> c1or2.take(source()); // Could call either implementation
    }

    switch(c1or2) {
      case C1 c1 -> { }
      default -> c1or2.take(source()); // Can't call C1.take
    }

    switch(c1or2) {
      case C1 c1 -> { }
      case null, default -> c1or2.take(source()); // Can't call C1.take
    }

  }

}
