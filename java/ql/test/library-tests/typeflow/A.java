import java.util.*;

public class A extends ArrayList<Long> {
  Object f1 = null;
  Object f2 = new ArrayList<Long>();

  public void m1(List<Long> l, List<Integer> l2) {
    f1 = new ArrayList<Long>();
    f2 = f1;
    f2 = l;
    Object x = m2(f2, l.size());
    Object z = x;
    Object y = l.isEmpty() ? this : (Object)null;
    z = y;
    if (l.size() > 3)
      y = (Object)new ArrayList<Integer>();
    else
      y = l2;
    z = y;
  }

  private Object m2(Object o, int i) {
    if (i == 7)
      return null;
    else if (i == 8)
      return o;
    else
      return new ArrayList<Long>();
  }

  public void m3(Set<Integer> s) {
    Object r;
    for (Object x : s) {
      r = x;
    }
    for (Object x : new A[3]) {
      r = x;
    }
  }

  public Object m4(Object o) {
    if (o instanceof Long) {
      return o;
    }
    return o;
  }

  public Object m5(Object o) {
    try {
      Integer i = (Integer)o;
      Object o2 = o;
    } catch(ClassCastException cce) {
      return o;
    }
    return o;
  }

  public void m6(int[] xs) {
    Object r;
    for (Object x : xs) {
      r = x;
    }
  }

  public void m7() {
    Object x = 7;
    int i = (Integer)x;
    int j = i;
    Object x2 = (Integer)7;
    int i2 = (Integer)x2;
    int j2 = i2;
  }

  public static class C {
    private Map<String, String> map;
    public static C empty = new C(Collections.emptyMap());
    private C(Map<String, String> map) {
      this.map = map;
    }
    public C() {
      this(new LinkedHashMap<>());
    }
    public void put(String k, String v) {
      map.put(k, v);
      empty.put(k, v);
    }
  }

  public void m8(Object[] xs, int i) {
    if (xs[i] instanceof Integer) {
      Object n = xs[i];
      Object r = n;
    }
  }
}
