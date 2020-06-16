import java.util.*;

public class C {

  public void ex1(long[][][] a1, int ix, int len) {
    long[][] a2 = null;
    boolean haveA2 = ix < len && (a2 = a1[ix]) != null;
    long[] a3 = null;
    final boolean haveA3 = haveA2 && (a3 = a2[ix]) != null; // NPE - false positive
    if (haveA3) a3[0] = 0; // NPE - false positive
  }

  public void ex2(boolean x, boolean y) {
    String s1 = x ? null : "";
    String s2 = (s1 == null) ? null : "";
    if (s2 == null) {
      s1 = y ? null : "";
      s2 = (s1 == null) ? null : "";
    }
    if (s2 != null)
      s1.hashCode(); // NPE - false positive
  }

  public void ex3(List<String> ss) {
    String last = null;
    for (String s : new String[] { "aa", "bb" }) {
      last = s;
    }
    last.hashCode(); // OK

    last = null;
    if (!ss.isEmpty()) {
      for (String s : ss) {
        last = s;
      }
      last.hashCode(); // OK
    }
  }

  public void ex4(Iterable<String> list, int step) {
    int index = 0;
    List<List<String>> result = new ArrayList<>();
    List<String> slice = null;
    Iterator<String> iter = list.iterator();
    while (iter.hasNext()) {
      String str = iter.next();
      if (index % step == 0) {
        slice = new ArrayList<>();
        result.add(slice);
      }
      slice.add(str); // NPE - false positive
      ++index;
      iter.remove();
    }
  }

  public void ex5(boolean hasArr, int[] arr) {
    int arrLen = 0;
    if (hasArr) {
      arrLen = arr == null ? 0 : arr.length;
    }
    if (arrLen > 0) {
      arr[0] = 0; // NPE - false positive
    }
  }

  public final int MY_CONST_A = 1;
  public final int MY_CONST_B = 2;
  public final int MY_CONST_C = 3;

  public void ex6(int[] vals, boolean b1, boolean b2) {
    final int switchguard;
    if (vals != null && b1) {
      switchguard = MY_CONST_A;
    } else if (vals != null && b2) {
      switchguard = MY_CONST_B;
    } else {
      switchguard = MY_CONST_C;
    }
    switch (switchguard) {
      case MY_CONST_A:
        vals[0] = 0; // OK
        break;
      case MY_CONST_C:
        break;
      case MY_CONST_B:
        vals[0] = 0; // OK
        break;
      default:
        throw new RuntimeException();
    }
  }

  public void ex7(int[] arr1) {
    int[] arr2 = null;
    if (arr1.length > 0) {
      arr2 = new int[arr1.length];
    }
    for (int i = 0; i < arr1.length; i++)
      arr2[i] = arr1[i]; // NPE - false positive
  }

  public void ex8(int x, int lim) {
    boolean stop = x < 1;
    int i = 0;
    Object obj = new Object();
    while (!stop) {
      int j = 0;
      while (!stop && j < lim) {
        int step = (j * obj.hashCode()) % 10; // NPE - false positive
        if (step == 0) {
          obj.hashCode();
          i += 1;
          stop = i >= x;
          if (!stop) {
            obj = new Object();
          } else {
            obj = null;
          }
          continue;
        }
        j += step;
      }
    }
  }

  public void ex9(boolean cond, Object obj1) {
    if (cond) {
      return;
    }
    Object obj2 = obj1;
    if (obj2 != null && obj2.hashCode() % 5 > 2) {
      obj2.hashCode();
      cond = true;
    }
    if (cond) {
      obj2.hashCode(); // NPE - false positive
    }
  }

  public void ex10(int[] a) {
    int n = a == null ? 0 : a.length;
    for (int i = 0; i < n; i++) {
      int x = a[i]; // NPE - false positive
      if (x > 7)
        a = new int[n];
    }
  }

  public void ex11(Object obj, Boolean b1) {
    Boolean b2 = obj == null ? Boolean.FALSE : b1;
    if (b2 == null) {
      obj.hashCode(); // OK
    }
    if (obj == null) {
      b1 = Boolean.TRUE;
    }
    if (b1 == null) {
      obj.hashCode(); // OK
    }
  }

  private final Object finalObj = new Object();

  public void ex12() {
    finalObj.hashCode(); // OK
    if (finalObj != null) {
      finalObj.hashCode(); // OK
    }
  }

  private void verifyBool(boolean b) {
    if (!b) {
      throw new Exception();
    }
  }

  public void ex13(int[] a) {
    int i = 0;
    boolean b = false;
    Object obj = null;
    while (a[++i] != 0) {
      if (a[i] == 1) {
        obj = new Object();
        b = true;
      } else if (a[i] == 2) {
        verifyBool(b);
        obj.hashCode(); // NPE - false positive
      }
    }
  }

  private void verifyNotNull(Object obj) {
    if (obj == null) {
      throw new Exception();
    }
  }

  public void ex14(int[] a) {
    int i = 0;
    Object obj = null;
    while (a[++i] != 0) {
      if (a[i] == 1) {
        obj = new Object();
      } else if (a[i] == 2) {
        verifyNotNull(obj);
        obj.hashCode(); // NPE - false positive
      }
    }
  }

  public void ex15(Object o1, Object o2) {
    if (o1 == null && o2 != null) {
      return;
    }
    if (o1 == o2) {
      return;
    }
    if (o1.equals(o2)) { // NPE - false positive
      return;
    }
  }

  private Object foo16;

  private Object getFoo16() {
    return this.foo16;
  }

  public static void ex16(C c) {
    int[] xs = c.getFoo16() != null ? new int[5] : null;
    if (c.getFoo16() != null) {
      xs[0]++; // NPE - false positive
    }
  }

  public static final int MAXLEN = 1024;

  public void ex17() {
    int[] xs = null;
    // loop executes at least once
    for (int i = 32; i <= MAXLEN; i *= 2) {
      xs = new int[5];
    }
    xs[0]++; // OK
  }
}
