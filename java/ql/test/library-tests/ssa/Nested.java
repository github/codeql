import java.util.*;

class Nested {
  Iterable<Integer> get1(int p1) {
    int x1 = 5;
    return () -> new Iterator() {
      public boolean hasNext() { return true; }
      public Integer next() { return p1 + x1 + x1 + x1; }
    };
  }

  interface IntGetter { int getInt(); }

  void methodRef() {
    Object obj = new Object();
    IntGetter hash = obj::hashCode;
    int x2 = 19;
    IntGetter h2 = new IntGetter() {
      public int getInt() {
        IntGetter hnest = obj::hashCode;
        return x2 + hash.getInt() + hnest.getInt();
      }
    };
    Object obj2 = new Object();
    if (h2.getInt() > 3) {
      obj2 = new Object();
    } else {
      obj2 = new Object();
    }
    IntGetter hash2 = obj2::hashCode;
  }

  IntGetter lambda1(int p3) {
    int x3;
    if (p3 > 7) {
      x3 = 1;
      return () -> x3 + 1;
    } else {
      x3 = 2;
      return () -> x3 + 2;
    }
  }
}
