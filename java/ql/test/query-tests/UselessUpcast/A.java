public class A<X extends A<X>> {
  private void m() { }
  private int pi;

  private void f(X x) {
    ((A<X>)x).m(); // OK
    int i = ((A<X>)x).pi; // OK
  }
}
