package my.qltest;

public class A {
  void foo() {
    Object x;
    x = src1();
    x = src1("");

    Sub sub = new Sub();
    x = sub.src2();
    x = sub.src3();

    srcArg(x);

    Handler h = srcparam1 -> { };

    Handler h2 = new Handler() {
      @Override public void handle(Object srcparam2) { }
    };

    x = taggedSrcMethod();
    x = taggedSrcField;

    x = srcTwoArg("", "");
  }

  @Tag
  void tagged1(Object taggedMethodParam) {
  }

  void tagged2(@Tag Object taggedSrcParam) {
  }

  Object src1() { return null; }

  Object src1(String s) { return null; }

  Object src2() { return null; }

  Object src3() { return null; }

  static class Sub extends A {
    // inherit src2
    @Override Object src3() { return null; }
  }

  void srcArg(Object src) { }

  interface Handler {
    void handle(Object src);
  }

  @interface Tag { }

  @Tag
  Object taggedSrcMethod() { return null; }

  @Tag
  Object taggedSrcField;

  Object srcTwoArg(String s1, String s2) { return null; }
}
