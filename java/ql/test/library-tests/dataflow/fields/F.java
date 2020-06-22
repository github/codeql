public class F {
  Object Field1;
  Object Field2;
  public F() {
    Field1 = new Object();
    Field2 = new Object();
  }

  private void m() {
    Object o = new Object();
    F f = new F();
    f.Field1 = o;
    f.Field2 = o;
    f.Field2 = null;
    sink(f.Field1); // flow
    sink(f.Field2); // no flow

    f = new F();
    f.Field2 = null;
    sink(f.Field1); // flow
    sink(f.Field2); // no flow

    f = new F();
    o = new Object();
    f.Field1 = o;
    f.Field2 = o;
    m2(f);
  }

  private void m2(F f)
  {
    f.Field2 = null;
    sink(f.Field1); // flow
    sink(f.Field2); // no flow
  }

  public static void sink(Object o) { }
}
