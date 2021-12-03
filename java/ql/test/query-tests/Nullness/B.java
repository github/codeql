public class B {
  private boolean maybe;
  public final boolean flag;
  public B(boolean b, boolean f) {
    this.maybe = b;
    this.flag = f;
  }

  public void caller() {
    callee1(new Object());
    callee1(null);
    callee2(new Object());
  }

  public void callee1(Object param) {
    param.toString(); // NPE
  }

  public void callee2(Object param) {
    if (param != null) {
      param.toString(); // OK
    }
    param.toString(); // NPE
  }

  private static boolean customIsNull(Object x) {
    if (x instanceof String) return false;
    if (x == null) return true;
    return x == null;
  }

  public void nullGuards() {
    Object o1 = maybe ? null : new Object();
    if (o1 != null) o1.hashCode(); // OK

    Object o2 = maybe ? null : "";
    if (o2 instanceof String) o2.hashCode(); // OK

    Object o3 = null;
    if ((o3 = maybe ? null : "") != null) o3.hashCode(); // OK

    Object o4 = maybe ? null : "";
    if ((2 > 1 && o4 != null) != false) o4.hashCode(); // OK

    Object o5 = (o4 != null) ? "" : null;
    if (o5 != null) o4.hashCode(); // OK
    if (o4 != null) o5.hashCode(); // OK

    Object o6 = maybe ? null : "";
    if (!customIsNull(o6)) o6.hashCode(); // OK

    Object o7 = maybe ? null : "";
    boolean ok = o7 != null && 2 > 1;
    if (ok)
      o7.hashCode(); // OK
    else
      o7.hashCode(); // NPE

    Object o8 = maybe ? null : "";
    int track = o8 == null ? 42 : 1+1;
    if (track == 2) o8.hashCode(); // OK
    if (track != 42) o8.hashCode(); // OK
    if (track < 42) o8.hashCode(); // OK
    if (track <= 41) o8.hashCode(); // OK
  }

  public void deref() {
    int[] xs = maybe ? null : new int[2];
    if (2 > 1) xs[0] = 5; // NPE
    if (2 > 1) maybe = xs[1] > 5; // NPE
    if (2 > 1) {
      int l = xs.length; // NPE
    }
    if (2 > 1) {
      for (int i : xs) { } // NPE
    }
    if (2 > 1) {
      synchronized(xs) { // NPE
        xs.hashCode(); // Not reported - same basic block
      }
    }
    if (4 > 3) {
      assert xs != null;
      xs[0] = xs[1]; // OK
    }
  }

  public void f(boolean b) {
    String x = b ? null : "abc";
    x = x == null ? "" : x;
    if (x == null)
      x.hashCode(); // OK - dead
    else
      x.hashCode(); // OK
  }

  public void lengthGuard(int[] a, int[] b) {
    int alen = a == null ? 0 : a.length; // OK
    int blen = b == null ? 0 : b.length; // OK
    int sum = 0;
    if (alen == blen) {
      for(int i = 0; i < alen; i++) {
        sum += a[i]; // OK
        sum += b[i]; // OK
      }
    }
    int alen2;
    if (a != null)
      alen2 = a.length; // OK
    else
      alen2 = 0;
    for(int i = 1; i <= alen2; ++i) {
      sum += a[i-1]; // OK
    }
  }

  public void missedGuard(Object obj) {
    obj.hashCode(); // NPE
    int x = obj != null ? 1 : 0;
  }

  private Object mkMaybe() {
    if (maybe) throw new RuntimeException();
    return new Object();
  }

  public void exceptions() {
    Object obj = null;
    try {
      obj = mkMaybe();
    } catch(Exception e) {
    }
    obj.hashCode(); // NPE

    Object obj2 = null;
    try {
      obj2 = mkMaybe();
    } catch(Exception e) {
      assert false;
    }
    obj2.hashCode(); // OK

    Object obj3 = null;
    try {
      obj3 = mkMaybe();
    } finally {
      //cleanup
    }
    obj3.hashCode(); // OK
  }

  public void clearNotNull() {
    Object o = new Object();
    if (o == null) o.hashCode(); // OK
    o.hashCode(); // OK

    try {
      mkMaybe();
    } catch(Exception e) {
      if (e == null) e.hashCode(); // OK
      e.hashCode(); // OK
    }

    Object n = null;
    Object o2 = n == null ? new Object() : n;
    o2.hashCode(); // OK

    Object o3 = "abc";
    if (o3 == null) o3.hashCode(); // OK
    o3.hashCode(); // OK

    Object o4 = "" + null;
    if (o4 == null) o4.hashCode(); // OK
    o4.hashCode(); // OK
  }

  public void correlatedConditions(boolean cond, int num) {
    Object o = null;
    if (cond) o = new Object();
    if (cond) o.hashCode(); // OK

    o = null;
    if (flag) o = "";
    if (flag) o.hashCode(); // OK

    o = null;
    Object other = maybe ? null : "";
    if (other == null) o = "";
    if (other != null)
      o.hashCode(); // NPE
    else
      o.hashCode(); // OK

    Object o2 = (num < 0) ? null : "";
    if (num < 0)
      o2 = "";
    else
      o2.hashCode(); // OK
  }

  public void trackingVariable(int[] a) {
    Object o = null;
    Object other = null;
    if (maybe) {
      o = "abc";
      other = "def";
    }
    if (other instanceof String) o.hashCode(); // OK

    o = null;
    int count = 0;
    boolean found = false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] == 42) {
        o = ((Integer)a[i]).toString();
        count++;
        if (2 > 1) { }
        found = true;
      }
      if (a[i] > 10000) {
        o = null;
        count = 0;
        if (2 > 1) { }
        found = false;
      }
    }
    if (count > 3) o.hashCode(); // OK
    if (found) o.hashCode(); // OK

    Object prev = null;
    for (int i = 0; i < a.length; ++i) {
      if (i != 0) prev.hashCode(); // OK
      prev = a[i];
    }

    String s = null;
    if (2 > 1) {
      boolean s_null = true;
      for (int i : a) {
        s_null = false;
        s = "" + a;
      }
      if (!s_null) s.hashCode(); // OK
    }

    Object r = null;
    MyStatus stat = MyStatus.INIT;
    while (stat == MyStatus.INIT && stat != MyStatus.READY) {
      r = mkMaybe();
      if (2 > 1)
        stat = MyStatus.READY;
    }
    r.hashCode(); // OK
  }

  public enum MyStatus {
    READY,
    INIT
  }

  public void g(Object obj) {
    String msg = null;
    if(obj == null)
      msg = "foo";
    else if(obj.hashCode() > 7) { // OK
      msg = "bar";
    }
    if(msg != null) {
      msg += "foobar";
      throw new RuntimeException(msg);
    }
    obj.hashCode(); // OK
  }

  public void loopCorr(int iters) {
    int[] a = null;
    if (iters > 0) a = new int[iters];
    for (int i = 0; i < iters; ++i)
      a[i] = 0; // NPE - false positive

    if (iters > 0) {
      String last = null;
      for (int i = 0; i < iters; i++) last = "abc";
      last.hashCode(); // OK
    }

    int[] b = maybe ? null : new int[iters];
    if (iters > 0 && (b == null || b.length < iters)) {
      throw new RuntimeException();
    }
    for (int i = 0; i < iters; ++i) {
      b[i] = 0; // NPE - false positive
    }
  }

  void test(Exception e, boolean b) {
    Exception ioe = null;
    if (b) {
      ioe = new Exception("");
    }
    if (ioe != null) {
      ioe = e;
    } else {
      ioe.getMessage(); // NPE; always
    }
  }

  public void lengthGuard2(int[] a, int[] b) {
    int alen = a == null ? 0 : a.length; // OK
    int sum = 0;
    int i;
    for(i = 0; i < alen; i++) {
      sum += a[i]; // OK
    }
    int blen = b == null ? 0 : b.length; // OK
    for(i = 0; i < blen; i++) {
      sum += b[i]; // OK
    }
    i = -3;
  }

  public void corrConds2(Object x, Object y) {
    if ((x != null && y == null) || (x == null && y != null)) return;
    if (x != null) y.hashCode(); // OK
    if (y != null) x.hashCode(); // OK
  }

  public void corrConds3(Object y) {
    Object x = null;
    if(y instanceof String) {
      x = new Object();
    }
    if(y instanceof String) {
      x.hashCode(); // OK
    }
  }

  public void corrConds4(Object y) {
    Object x = null;
    if(!(y instanceof String)) {
      x = new Object();
    }
    if(!(y instanceof String)) {
      x.hashCode(); // OK
    }
  }

  public void corrConds5(Object y, Object z) {
    Object x = null;
    if(y == z) {
      x = new Object();
    }
    if(y == z) {
      x.hashCode(); // OK
    }

    Object x2 = null;
    if(y != z) {
      x2 = new Object();
    }
    if(y != z) {
      x2.hashCode(); // OK
    }

    Object x3 = null;
    if(y != z) {
      x3 = new Object();
    }
    if(!(y == z)) {
      x3.hashCode(); // OK
    }
  }

}
