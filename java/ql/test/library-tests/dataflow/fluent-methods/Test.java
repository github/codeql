public class Test {

  private String field;

  public Test fluentNoop() {
    return this;
  }

  public Test indirectlyFluentNoop() {
    return this.fluentNoop();
  }

  public Test fluentSet(String x) {
    this.field = x;
    return this;
  }

  public static Test identity(Test t) {
    return t;
  }

  public String get() {
    return field;
  }

  public static String source() {
    return "taint";
  }

  public static void sink(String s) {}

  public static void test1() {
    Test t = new Test();
    t.fluentNoop().fluentSet(source()).fluentNoop();
    sink(t.get()); // $hasTaintFlow=y
  }

  public static void test2() {
    Test t = new Test();
    Test.identity(t).fluentNoop().fluentSet(source()).fluentNoop();
    sink(t.get()); // $hasTaintFlow=y
  }

  public static void test3() {
    Test t = new Test();
    t.indirectlyFluentNoop().fluentSet(source()).fluentNoop();
    sink(t.get()); // $hasTaintFlow=y
  }

}
