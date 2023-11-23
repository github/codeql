import java.util.*;
import java.util.function.*;

public class A {
  static String source(String tag) { return null; }

  static void sink(Object o) { }

  interface MyConsumer {
    void run(Object o);
  }

  void apply(MyConsumer f, Object x) {
    f.run(x);
  }

  void apply_wrap(MyConsumer f, Object x) {
    apply(f, x);
  }

  void testLambdaDispatch1() {
    apply_wrap(x -> { sink(x); }, source("A")); // $ hasValueFlow=A
    apply_wrap(x -> { sink(x); }, null); // no flow
    apply_wrap(x -> { }, source("B"));
    apply_wrap(x -> { }, null);
  }

  void forEach_wrap(List<Object> l, Consumer<Object> f) {
    l.forEach(f);
  }

  void testLambdaDispatch2() {
    List<Object> tainted = new ArrayList<>();
    tainted.add(source("L"));
    List<Object> safe = new ArrayList<>();
    forEach_wrap(safe, x -> { sink(x); }); // no flow
    forEach_wrap(tainted, x -> { sink(x); }); // $ hasValueFlow=L
  }

  static class TaintedClass {
    public String toString() { return source("TaintedClass"); }
  }

  static class SafeClass {
    public String toString() { return "safe"; }
  }

  String convertToString(Object o) {
    return o.toString();
  }

  String convertToString_wrap(Object o) {
    return convertToString(o);
  }

  void testToString1() {
    String unused = convertToString_wrap(new TaintedClass());
    sink(convertToString_wrap(new SafeClass())); // no flow
  }
}
