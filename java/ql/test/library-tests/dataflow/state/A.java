import java.util.function.*;

public class A {
  Object source(String state) { return null; }

  void sink(Object x, String state) { }

  void stateBarrier(Object x, String state) { }

  Object step(Object x, String s1, String s2) { return null; }

  void check(Object x) { }

  void test1() {
    Object x = source("A");
    check(x); // $ pFwd=A-A pRev=A-B
    x = step(x, "A", "B");
    check(x); // $ pFwd=A-B pRev=A-A pRev=B-B
    sink(x, "A");
    sink(x, "B"); // $ flow=A
  }

  void test2(Supplier<Boolean> b) {
    Object x = b.get() ? source("A") : source("B");
    check(x); // $ pFwd=A-A pFwd=B-B pRev=B-B pRev=B-C pRev=C-C
    x = b.get() ? x : step(x, "B", "C");
    check(x); // $ pFwd=A-A pFwd=B-B pFwd=B-C pRev=B-B pRev=C-C
    stateBarrier(x, "A");
    check(x); // $ pFwd=B-B pFwd=B-C pRev=A-A pRev=B-B pRev=C-C
    sink(x, "A");
    sink(x, "B"); // $ flow=B
    sink(x, "C"); // $ flow=B
  }
}
