public class Test {

  public static int source() { return 0; }
  public static void sink(int x) { }

  interface I { void take(int x); }
  static class C1 implements I { public void take(int x) { sink(x); } }
  static class C2 implements I { public void take(int x) { sink(x); } }
  record Wrapper(Object o) implements I { public void take(int x) { sink(x); } }
  record WrapperWrapper(Wrapper w) implements I { public void take(int x) { sink(x); } }

  public static void test(int unknown, int alsoUnknown) {

    I i = unknown == 0 ? new C1() : unknown == 1 ? new C2() : unknown == 2 ? new Wrapper(new Object()) : new WrapperWrapper(new Wrapper(new Object()));

    switch(i) {
      case C1 c1 when alsoUnknown == 1 -> { }
      default -> i.take(source()); // Could call any implementation
    }

    switch(i) {
      case C1 c1 -> { }
      default -> i.take(source()); // Can't call C1.take
    }

    switch(i) {
      case C1 c1 -> { }
      case null, default -> i.take(source()); // Can't call C1.take (but we don't currently notice)
    }

    switch(i) {
      case Wrapper w -> { }
      default -> i.take(source()); // Can't call Wrapper.take
    }

    switch(i) {
      case Wrapper(Object o) -> { }
      default -> i.take(source()); // Can't call Wrapper.take
    }

    switch(i) {
      case Wrapper(String s) -> { }
      default -> i.take(source()); // Could call any implementation, because this might be a Wrapper(Integer) for example.
    }

    switch(i) {
      case WrapperWrapper(Wrapper(Object o)) -> { }
      default -> i.take(source()); // Can't call WrapperWrapper.take
    }

    switch(i) {
      case WrapperWrapper(Wrapper(String s)) -> { }
      default -> i.take(source()); // Could call any implementation, because this might be a WrapperWrapper(Wrapper((Integer)) for example.
    }

    switch(i) {
      case C1 c1: break;
      case null: default: i.take(source()); // Can't call C1.take (but we don't currently notice)
    }

    switch(i) {
      case C1 _, C2 _:
        i.take(source()); // Must be either C1.take or C2.take (but we don't currently notice, because neither dominates)
        break;
      default: 
        i.take(source()); // Can't call C1.take or C2.take (but we don't currently notice, because a multi-pattern case isn't understood as a type test)
    }

    switch(i) {
      case C1 _, C2 _ when i.toString().equals("abc"):
        i.take(source()); // Must be either C1.take or C2.take (but we don't currently notice, because neither dominates)
        break;
      default: 
        i.take(source()); // Can't call C1.take or C2.take (but we don't currently notice, because a multi-pattern case isn't understood as a type test)
    }

    switch(i) {
      case C1 _:
      case C2 _:
        i.take(source()); // Must be either C1.take or C2.take (but we don't currently notice, because neither dominates)
        break;
      default:
        i.take(source()); // Can't call C1.take or C2.take
    }

  }

}
