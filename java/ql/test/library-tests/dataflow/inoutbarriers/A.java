class A {
  static String fsrc = "";

  String src(String s) { return s; }

  void sink(String s) { }

  void foo() {
    String s = fsrc;
    sink(fsrc);

    s = src(s);
    sink(s);

    sink(s);
  }
}
