import java.util.function.*;

class A {
  Object source(String label) { return null; }

  void sink(Object o) { }

  <T> T propagateTaint(Object arg) {
    return (T)arg;
  }

  void test() {
    // test type strengthening on outgoing through-flow edge
    String s = this.<String>propagateTaint(source("A"));
    sink(s); // $ hasValueFlow=A

    // no strengthening
    Object o = this.<Object>propagateTaint(source("B"));
    sink(o); // $ hasValueFlow=B

    // test type strengthening on ingoing through-flow edge
    String s2 = apply((String arg) -> arg, source("C"));
    sink(s2); // $ hasValueFlow=C
  }

  <T1, T2> T2 apply(Function<T1, T2> f, Object x) {
    return f.apply((T1)x);
  }
}
