package my.qltest;

public class B {
  void foo() {
    Object arg1 = new Object();
    sink1(arg1);

    Object argToTagged = new Object();
    taggedSinkMethod(argToTagged);

    Object fieldWrite = new Object();
    taggedField = fieldWrite;
  }

  Object sinkMethod() {
    Object res = new Object();
    return res;
  }

  @Tag
  Object taggedSinkMethod() {
    Object resTag = new Object();
    return resTag;
  }

  void sink1(Object x) { }

  @interface Tag { }

  @Tag
  void taggedSinkMethod(Object x) { }

  @Tag
  Object taggedField;
}
