class A {
  static String fsrc = "";
  String fsink = "";

  String src(String s) { return s; }

  void sink(String s) { }

  static String flowThroughSink(String s) {
    A obj = new A();
    obj.fsink = s;
    return obj.fsink;
  }

  void foo() {
    String s = fsrc;
    sink(fsrc);

    s = src(s);
    sink(s);

    sink(s);

    s = fsrc;
    s = flowThroughSink(s);
    sink(s);
  }
}
