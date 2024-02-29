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
}
