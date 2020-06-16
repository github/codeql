public class Varargs {
  public String taint() { return "tainted"; }

  public void sink(String s) { }

  public void sources() {
    f1(taint());
    f2(taint(), taint());
    f3(new String[] { taint(), "" });
  }

  public void f1(String... ss) {
    String s = ss[0];
    sink(s);
  }

  public void f2(String... ss) {
    String s = ss[0];
    sink(s);
  }

  public void f3(String... ss) {
    String s = ss[0];
    sink(s);
  }
}
