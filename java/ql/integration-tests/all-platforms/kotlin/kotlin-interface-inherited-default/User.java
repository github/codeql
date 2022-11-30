public class User {

  public static void sink(int x) { }

  // Real is compiled with synthetic interface method forwarders, so it appears from a Java perspective to override the interface Test.
  // RealNoForwards is compiled with -Xjvm-default=all, meaning real Java 8 default interface methods are used, no synthetic forwarders
  // are created, and call resolution should go straight to the default.
  // RealIndirect is similar to Real, except it inherits its methods indirectly via MiddleInterface.
  public static void test(Real r1, RealNoForwards r2, RealIndirect r3) {

    sink(r1.f());
    sink(r1.g(2));
    sink(r1.getX());

    sink(r2.f());
    sink(r2.g(5));
    sink(r2.getX());

    sink(r3.f());
    sink(r3.g(8));
    sink(r3.getX());

  }

}
