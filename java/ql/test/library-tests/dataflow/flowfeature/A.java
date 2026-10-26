public class A {
  static Object source(String s) { return null; }
  static void sink(Object o) { }

  static Object id(Object x) { return x; }

  static void test1(int dummy) {
    Object src = source("1");
    Object a = src;
    sink(a); // $ EqCc="1" SrcCc="1" SinkCc="1"
  }

  static void test2() {
    Object src = source("2");
    Object a = src;
    sink(a); // $ EqCc="2" SrcCc="2" SinkCc="2"
  }

  void test3() {
    Object src = source("3");
    Object a = id(src);
    sink(a); // $ EqCc="3" SrcCc="3" SinkCc="3"
  }

  static void test4() {
    Object src = source("4");
    Object a = id(src);
    sink(a); // $ EqCc="4" SrcCc="4" SinkCc="4"
  }

  static Object test5src() {
    return source("5");
  }

  static void test5() {
    Object x = test5src();
    Object y = id(x);
    sink(y); // $ SinkCc="5"
  }

  static void test6sink(Object x) {
    sink(x); // $ SrcCc="6"
  }

  static void test6() {
    Object x = source("6");
    test6sink(x);
  }

  Object getSrc() {
    return source("get");
  }

  void srcField() {
    foo = source("field");
  }

  static Object foo = null;

  void srcCall(int i) {
    test7(source("call"), i);
  }

  Object test7(Object x, int i) {
    Object src = null;
    if (i == 0) {
      src = getSrc();
    } else if (i == 1) {
      src = foo;
    } else if (i == 2) {
      src = x;
    } else if (i == 3) {
      src = source("direct");
    }

    sinkPut(src);
    foo2 = src;
    sink(src); // $ EqCc="direct" SrcCc="field" SrcCc="call" SrcCc="direct" SinkCc="get" SinkCc="field" SinkCc="direct"
    return src;
  }

  static Object foo2 = null;

  void sinkPut(Object x) {
    sink(x); // $ SrcCc="field" SrcCc="call" SrcCc="direct"
  }

  void sinkField() {
    sink(foo2); // $ SrcCc="field" SrcCc="call" SrcCc="direct" SinkCc="get" SinkCc="field" SinkCc="call" SinkCc="direct"
  }

  void sinkReturn(int i) {
    sink(test7(null, i)); // $ SrcCc="field" SinkCc="get" SinkCc="field" SinkCc="direct"
  }
}
