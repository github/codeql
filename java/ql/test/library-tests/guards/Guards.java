public class Guards {
  static void chk() { }

  static boolean g(Object lbl) { return lbl.hashCode() > 10; }

  static void checkTrue(boolean b, String msg) {
    if (!b) throw new Error(msg);
  }

  static void checkFalse(boolean b, String msg) {
    checkTrue(!b, msg);
  }

  void t1(int[] a, String s) {
    if (g("A")) {
      chk(); // $ guarded=g(A):true
    } else {
      chk(); // $ guarded=g(A):false
    }

    boolean b = g(1) ? g(2) : true;
    if (b != false) {
      chk(); // $ guarded=...?...:...:true guarded='b != false:true' guarded=b:true
    } else {
      chk(); // $ guarded=...?...:...:false guarded='b != false:false' guarded=b:false guarded=g(1):true guarded=g(2):false
    }
    int sz = a != null ? a.length : 0;
    for (int i = 0; i < sz; i++) {
      chk(); // $ guarded='a != null:true' guarded='i < sz:true' guarded='sz:Lower bound 1' guarded='...?...:...:Lower bound 1' guarded='a.length:Lower bound 1' guarded='a:not null'
      int e = a[i];
      if (e > 2) break;
    }
    chk(); // nothing guards here

    if (g(3))
      s = "bar";
    switch (s) {
      case "bar":
        chk(); // $ guarded='s:match "bar"' guarded='s:bar'
        break;
      case "foo":
        chk(); // $ guarded='s:match "foo"' guarded='s:foo' guarded=g(3):false
        break;
      default:
        chk(); // $ guarded='s:non-match "bar"' guarded='s:non-match "foo"' guarded='s:not bar' guarded='s:not foo' guarded='s:match default' guarded=g(3):false
        break;
    }

    Object o = g(4) ? null : s;
    if (o instanceof String) {
      chk(); // $ guarded=...instanceof...:true guarded='o:not null' guarded='...?...:...:not null' guarded=g(4):false guarded='s:not null'
    }
  }

  void t2() {
    checkTrue(g(1), "A");
    checkFalse(g(2), "B");
    chk(); // $ guarded='checkTrue(...):no exception' guarded=g(1):true guarded='checkFalse(...):no exception' guarded=g(2):false
  }

  void t3() {
    boolean b = g(1) && (g(2) || g(3));
    if (b) {
      chk(); // $ guarded=b:true guarded='g(...) && ... \|\| ...:true' guarded=g(1):true guarded='g(...) \|\| g(...):true'
    } else {
      chk(); // $ guarded=b:false guarded='g(...) && ... \|\| ...:false'
    }
    b = g(4) || !g(5);
    if (b) {
      chk(); // $ guarded=b:true guarded='g(...) \|\| !...:true'
    } else {
      chk(); // $ guarded=b:false guarded='g(...) \|\| !...:false' guarded=g(4):false guarded=!...:false guarded=g(5):true
    }
  }

  enum Val {
    E1,
    E2,
    E3
  }

  void t4() {
    Val x = null; // unique value
    if (g(1)) x = Val.E1; // unique value
    if (g(2)) x = Val.E2;
    if (g("Alt2")) x = Val.E2;
    if (g(3)) x = Val.E3; // unique value
    if (x == null)
      chk(); // $ guarded='x == null:true' guarded='x:null' guarded=g(1):false guarded=g(2):false guarded=g(Alt2):false guarded=g(3):false
    switch (x) {
      case E1:
        chk(); // $ guarded='x:match E1' guarded='x:E1' guarded=g(1):true guarded=g(2):false guarded=g(Alt2):false guarded=g(3):false
        break;
      case E2:
        chk(); // $ guarded='x:match E2' guarded='x:E2' guarded=g(3):false
        break;
      case E3:
        chk(); // $ guarded='x:match E3' guarded='x:E3' guarded=g(3):true
        break;
    }
    Object o = g(4) ? new Object() : null;
    if (o == null) {
      chk(); // $ guarded='o == null:true' guarded='o:null' guarded='...?...:...:null' guarded=g(4):false
    } else {
      chk(); // $ guarded='o == null:false' guarded='o:not null' guarded='...?...:...:not null' guarded=g(4):true
    }
  }

  void t5(String foo) {
    String base = foo;
    if (base == null) {
      base = "/user";
    }
    if (base.equals("/"))
      chk(); // $ guarded=equals(/):true guarded='base:/' guarded='base:not null' guarded='base == null:false' guarded='foo:/' guarded='foo:not null'
  }

  void t6() {
    Object o = null;
    if (g(1)) {
      o = new Object();
      if (g(2)) { }
    }
    if (o != null) {
      chk(); // $ guarded='o != null:true' guarded='o:not null' guarded=g(1):true
    } else {
      chk(); // $ guarded='o != null:false' guarded='o:null' guarded=g(1):false
    }
  }

  void t7(int[] a) {
    boolean found = false;
    for (int i = 0; i < a.length; i++) {
      boolean answer = a[i] == 42;
      if (answer) {
        found = true;
      }
      if (found) {
        chk(); // $ guarded=found:true guarded='i < a.length:true' guarded='a.length:Lower bound 1'
      }
    }
    if (found) {
      chk(); // $ guarded=found:true guarded='i < a.length:false' guarded='i:Lower bound 0'
    }
  }

  public static boolean testNotNull1(String input) {
    return input != null && input.length() > 0;
  }

  public static boolean testNotNull2(String input) {
    if (input == null) return false;
    return input.length() > 0;
  }

  public static int getNumOrDefault(Integer number) {
    return number == null ? 0 : number;
  }

  public static String concatNonNull(String s1, String s2) {
    if (s1 == null || s2 == null) return null;
    return s1 + s2;
  }

  public static Status testEnumWrapper(boolean flag) {
    return flag ? Status.SUCCESS : Status.FAILURE;
  }

  enum Status { SUCCESS, FAILURE }

  void testWrappers(String s, Integer i) {
    if (testNotNull1(s)) {
      chk(); // $ guarded='s:not null' guarded=testNotNull1(...):true
    } else {
      chk(); // $ guarded=testNotNull1(...):false
    }

    if (testNotNull2(s)) {
      chk(); // $ guarded='s:not null' guarded=testNotNull2(...):true
    } else {
      chk(); // $ guarded=testNotNull2(...):false
    }

    if (0 == getNumOrDefault(i)) {
      chk(); // $ guarded='0 == getNumOrDefault(...):true' guarded='getNumOrDefault(...):0'
    } else {
      chk(); // $ guarded='0 == getNumOrDefault(...):false' guarded='getNumOrDefault(...):not 0' guarded='i:not 0' guarded='i:not null'
    }

    if (null == concatNonNull(s, "suffix")) {
      chk(); // $ guarded='concatNonNull(...):null' guarded='null == concatNonNull(...):true'
    } else {
      chk(); // $ guarded='concatNonNull(...):not null' guarded='null == concatNonNull(...):false' guarded='s:not null'
    }

    switch (testEnumWrapper(g(1))) {
      case SUCCESS:
        chk(); // $ guarded='testEnumWrapper(...):SUCCESS' guarded='testEnumWrapper(...):match SUCCESS' guarded=g(1):true
        break;
      case FAILURE:
        chk(); // $ guarded='testEnumWrapper(...):FAILURE' guarded='testEnumWrapper(...):match FAILURE' guarded=g(1):false
        break;
    }
  }

  static void ensureNotNull(Object o) throws Exception {
    if (o == null) throw new Exception();
  }

  void testExceptionWrapper(String s) throws Exception {
    chk(); // nothing guards here
    ensureNotNull(s);
    chk(); // $ guarded='ensureNotNull(...):no exception' guarded='s:not null'
  }
}
