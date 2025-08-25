public class Test {

  public static void test(boolean inp) {

    String directTaint = source();
    String indirectTaint = source();

    Object o = inp ? directTaint : new Outer(new Inner(indirectTaint, "not tainted"), "not tainted 2");

    if (o instanceof String s) {
      sink(s);
    }

    if (o instanceof Outer(Inner(String tainted, String notTainted), String alsoNotTainted)) {
      sink(tainted);
      sink(notTainted);
      sink(alsoNotTainted);
    }

  }

  public static String source() { return "tainted"; }
  public static void sink(String sunk) { }

}

record Outer(Inner i, String otherField) { }
record Inner(String taintedField, String nonTaintedField) { }
