public class Logic {
  boolean g(int i) {
    return i < 2;
  }

  void f(int[] a, String s) {
    boolean b =
        ((g(1)) ?
        g(2) :
        true);
    if (b != false) {
    } else {
    }
    int sz = a != null ? a.length : 0;
    for (int i = 0; i < sz; i++) {
      int e = a[i];
      if (e > 2) break;
    }
    if (g(3))
      s = "bar";
    switch (s) {
      case "bar":
        break;
      case "foo":
        break;
      default:
        break;
    }
    Object o = g(4) ? null : s;
    if (o instanceof String) {
    }
  }

  void f2(int i) {
    checkTrue(i > 0, "i pos");
    checkFalse(g(100), "g");
    if (i > 10) {
      checkTrue(i > 20, "");
    }
    int dummy = 0;
  }

  private static void checkTrue(boolean b, String msg) {
    if (!b) throw new Exception(msg);
  }

  private static void checkFalse(boolean b, String msg) {
    checkTrue(!b, msg);
  }
}
