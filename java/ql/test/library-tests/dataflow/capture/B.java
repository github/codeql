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

  void testNested() {
    List<String> l1 = new ArrayList<>();
    List<List<String>> l2 = new ArrayList<>();
    l1.add(source("nest.out"));
    l2.add(l1);
    String s = source("nest.in");
    List<String> out1 = new ArrayList<>();
    List<String> out2 = new ArrayList<>();
    l2.forEach(l -> l.forEach(x -> {
      sink(s); // $ hasValueFlow=nest.in
      out1.add(x);
      out2.add(s);
    }));
    sink(out1.get(0)); // $ hasValueFlow=nest.out
    sink(out2.get(0)); // $ hasValueFlow=nest.in
  }

  static interface TwoRuns {
    void run1();
    void run2();
  }

  void testAnonymousClass() {
    List<String> l1 = new ArrayList<>();
    List<String> l2 = new ArrayList<>();
    TwoRuns r = new TwoRuns() {
      @Override
      public void run1() {
        l1.add(source("run1"));
      }
      @Override
      public void run2() {
        l2.add(l1.get(0));
      }
    };
    r.run2();
    sink(l2.get(0));
    r.run1();
    r.run2();
    sink(l2.get(0)); // $ hasValueFlow=run1
  }

  void testLocalClass1() {
    String s = source("local1");
    class MyLocal {
      String f;
      MyLocal() { this.f = s; }
      String getF() { return this.f; }
    }
    MyLocal m = new MyLocal();
    sink(m.getF()); // $ hasValueFlow=local1
  }

  void testLocalClass2() {
    String s1 = source("s1");
    String s2 = source("s2");
    List<String> l = new ArrayList<>();
    class MyLocal {
      String f;
      MyLocal() {
        this.f = s1;
        sink(s2); // $ hasValueFlow=s2
      }
      void test() {
        sink(f); // $ hasValueFlow=s1
        sink(s2); // $ hasValueFlow=s2
      }
      void add(String s) {
        l.add(s);
      }
      String get() {
        return l.get(0);
      }
    }
    MyLocal m1 = new MyLocal();
    MyLocal m2 = new MyLocal();
    m1.test();
    sink(m1.get());
    m1.add(source("m1.add"));
    sink(m2.get()); // $ hasValueFlow=m1.add
  }

  void testComplex() {
    String s = source("complex");
    class LocalComplex {
      Supplier<StringBox> getBoxSupplier() {
        return new Supplier<StringBox>() {
          StringBox b = new StringBox();
          @Override
          public StringBox get() { return b; }
        };
      }
      class StringBox {
        String get() {
          // capture through regular nested class inside local nested class
          return s;
        }
      }
    }
    LocalComplex lc = new LocalComplex();
    sink(lc.getBoxSupplier().get().get()); // $ MISSING: hasValueFlow=complex
  }

  void testCapturedLambda() {
    String s = source("double.capture.in");
    List<String> out = new ArrayList<>();
    Runnable r1 = () -> {
      sink(s); // $ hasValueFlow=double.capture.in
      out.add(source("double.capture.out"));
    };
    Runnable r2 = () -> {
      r1.run();
    };
    r2.run();
    sink(out.get(0)); // $ hasValueFlow=double.capture.out
  }

  void testEnhancedForStmtCapture() {
    List<String> l = new ArrayList<>();
    l.add(source("list"));
    String[] a = new String[] { source("array") };
    for (String x : l) {
      Runnable r = () -> sink(x); // $ MISSING: hasValueFlow=list
      r.run();
    }
    for (String x : a) {
      Runnable r = () -> sink(x); // $ MISSING: hasValueFlow=array
      r.run();
    }
  }

  void testDoubleCall() {
    String s = source("src");
    List<String> l = new ArrayList<>();
    List<String> l2 = new ArrayList<>();
    class MyLocal2 {
      MyLocal2() {
        sink(l.get(0)); // no flow
        sink(l2.get(0)); // no flow
        l.add(s);
      }
      void run() {
        l2.add(l.get(0));
      }
    }
    // The ClassInstanceExpr has two calls in the same cfg node:
    // First the constructor call for which it is the postupdate,
    // and then as instance argument to the run call.
    new MyLocal2().run();
    sink(l.get(0)); // $ hasValueFlow=src
    sink(l2.get(0)); // $ hasValueFlow=src
  }

  void testInstanceInitializer() {
    // Tests capture in the instance initializer ("<obinit>")
    String s = source("init");
    class MyLocal3 {
      String f = s;
      void run() {
        sink(this.f); // $ hasValueFlow=init
      }
    }
    new MyLocal3().run();
  }

  void testConstructorIndirection() {
    // Tests capture in nested constructor call
    String s = source("init");
    class MyLocal4 {
      String f;
      MyLocal4() {
        this(42);
      }
      MyLocal4(int i) {
        f = s;
      }
      String get() {
        return this.f;
      }
    }
    sink(new MyLocal4().get()); // $ hasValueFlow=init
    sink(new MyLocal4(1).get()); // $ hasValueFlow=init
  }
}
