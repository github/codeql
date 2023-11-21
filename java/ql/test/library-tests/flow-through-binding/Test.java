public class Test {

  public static Object testFlowThroughSwitchStmt(String s, Integer i, boolean unknown) {
    Object o = unknown ? s : i;
    switch (o) {
      case Integer i2 -> { return (Object)i2; }
      default -> { return null; }
    }
  }

  public static Object testFlowThroughSwitchExpr(String s, Integer i, boolean unknown) {
    Object o = unknown ? s : i;
    Object toRet = switch (o) {
      case Integer i2 -> (Object)i2;
      default -> null;
    };
    return toRet;
  }

  public static Object testFlowThroughBindingInstanceOf(String s, Integer i, boolean unknown) {
    Object o = unknown ? s : i;
    if (o instanceof Integer i2)
      return (Object)i2;
    else
      return null;
  }

  public static <T> T source() { return null; }

  public static void sink(Object o) { }

  public static void test(boolean unknown, boolean unknown2) {

    String source1 = source();
    Integer source2 = source();
    sink(testFlowThroughSwitchStmt(source1, source2, unknown));
    sink(testFlowThroughSwitchExpr(source1, source2, unknown));
    sink(testFlowThroughBindingInstanceOf(source1, source2, unknown));

  }

}
