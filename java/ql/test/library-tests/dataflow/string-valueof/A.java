public class A {
  String source() { return "source"; }

  void sink(Object o) {}

  void m(char[] cs, char c, Object obj) {
    String s = source();

    sink(String.valueOf(s)); // $ hasTaintFlow

    CharSequence seq = s;
    sink(String.valueOf(seq)); // $ hasTaintFlow

    StringBuilder sb = new StringBuilder(s);
    sink(String.valueOf(sb)); // $ hasTaintFlow

    sink(String.valueOf(s.toCharArray())); // $ hasTaintFlow

    sink(String.valueOf(s.charAt(0))); // $ hasTaintFlow

    // `toString` on an arbitrary object is not assumed to expose the state of
    // the object, so no flow is expected here.
    Object o = s;
    sink(String.valueOf(o));
  }
}
