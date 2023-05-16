import java.util.*;
import java.util.function.*;

public class B {
  static String source(String label) { return null; }

  static void sink(String s) { }

  static void test1() {
    List<String> l1 = new ArrayList<>();
    l1.add(source("L"));
    List<String> l2 = new ArrayList<>();
    l1.forEach(e -> l2.add(e));
    sink(l2.get(0)); // $ hasValueFlow=L
  }

  String bf1;
  String bf2;

  void test2() {
    B other = new B();
    Consumer<String> f = x -> { this.bf1 = x; bf2 = x; other.bf1 = x; };

    // no flow
    sink(bf1);
    sink(this.bf2);
    sink(other.bf1);
    sink(other.bf2);

    f.accept(source("T"));

    sink(bf1); // $ MISSING: hasValueFlow=T
    sink(this.bf2); // $ MISSING: hasValueFlow=T
    sink(other.bf1); // $ hasValueFlow=T
    sink(other.bf2);
  }

  static void convert(Map<String, String> inp, Map<String, String> out) {
    inp.forEach((key, value) -> { out.put(key, value); });
  }

  void test3() {
    HashMap<String,String> m1 = new HashMap<>();
    HashMap<String,String> m2 = new HashMap<>();
    m1.put(source("Key"), source("Value"));
    convert(m1, m2);
    m2.forEach((k, v) -> {
      sink(k); // $ hasValueFlow=Key
      sink(v); // $ hasValueFlow=Value
    });
  }

  String elem;

  void testParamIn1() {
    elem = source("pin.This.elem");
    testParamIn2(source("pin.Arg"));
  }

  void testParamIn2(String param) {
    Runnable r = () -> {
      sink(elem); // $ MISSING: hasValueFlow=pin.This.elem
      sink(this.elem); // $ MISSING: hasValueFlow=pin.This.elem
      sink(param); // $ hasValueFlow=pin.Arg
    };
    r.run();
  }

  void testParamOut1() {
    B other = new B();
    testParamOut2(other);
    sink(elem); // $ MISSING: hasValueFlow=pout.This.elem
    sink(this.elem); // $ MISSING: hasValueFlow=pout.This.elem
    sink(other.elem); // $ hasValueFlow=pout.param
  }

  void testParamOut2(B param) {
    Runnable r = () -> {
      this.elem = source("pout.This.elem");
      param.elem = source("pout.param");
    };
    r.run();
  }

  void testCrossLambda() {
    B b = new B();
    Runnable sink1 = () -> { sink(b.elem); };
    Runnable sink2 = () -> { sink(b.elem); }; // $ hasValueFlow=src
    Runnable src = () -> { b.elem = source("src"); };
    doRun(sink1);
    doRun(src);
    doRun(sink2);
  }

  void doRun(Runnable r) {
    r.run();
  }
}
