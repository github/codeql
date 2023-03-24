public class Test {

  static class BoundedGeneric<T extends CharSequence> {
    public T getter(int unused) { return null; }
    public void setter(T t) { }
  }

  public static BoundedGeneric<?> getUnbounded() { return null; }

  public static BoundedGeneric<? super String> getLowerBounded() { return null; }

  public static void test() {
    CharSequence cs = getUnbounded().getter(0);
    Object o = getLowerBounded().getter(0);
    getUnbounded().setter(null);
    getLowerBounded().setter(null);
  }

}
