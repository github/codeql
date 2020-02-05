public class MethodFlow {
  public static String taint() { return "tainted"; }

  public static void sink(String s) { }

  public void test() {
    String tainted = taint();
    sink(tainted);
    String tainted2 = notNull(taint());
    sink(tainted2);
    String tainted3 = wrapNotNull(taint());
    sink(tainted3);

    String safe = notNull("a constant");
    sink(safe);

    String diffString = returnDiffString(taint());
    sink(diffString);
  }

  public <T> T notNull(T x) {
    if (x == null) {
      throw new NullPointerException();
    }
    return x;
  }

  public <T> T wrapNotNull(T x) {
    T res = notNull(x);
    sink("Logged: " + res);
    return res;
  }

  public String returnDiffString(String x) {
    sink("Received: " + x);
    return "OK";
  }
}
