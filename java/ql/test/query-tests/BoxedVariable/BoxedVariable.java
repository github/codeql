import java.util.*;

class Test {
  public void f() {
    Boolean done = false; // bad
    while (!done) {
      done = true;
    }

    Integer sum = 0; // bad
    for (int i = 0; i < 10; i++)
      sum += i;
    useBoxed(sum);

    Integer box = 42; // ok; only boxed usages
    useBoxed(box);

    Integer badbox = 17; // bad
    useBoxed(badbox);
    usePrim(badbox);

    Integer x = 1; // ok; null is used
    usePrim(x);
    x = null;

    Long y = getPrim(); // bad
    y = 15L;
    y = getPrim();
    boolean dummy = y > 0;

    Long z = getPrim(); // ok; has boxed assignment
    z = 2L;
    z = getBoxed();
    dummy = z > 0;
  }

  void forloop(List<Integer> l, int[] a) {
    int sum = 0;

    for (Integer okix : l) sum += okix; // ok; has boxed assignment

    for (Integer badix : a) sum += badix; // bad
  }

  void usePrim(int i) { }
  void useBoxed(Integer i) { }

  long getPrim() { return 42L; }
  Long getBoxed() { return 42L; }

  void overload() {
    Long x = 4L; // don't report; changing to long would change overload resolution
    boolean dummy = x > 0;
    assertEq(x, getBoxed());
  }

  static void assertEq(Object x, Object y) { }
  static void assertEq(long x, long y) { }
}
