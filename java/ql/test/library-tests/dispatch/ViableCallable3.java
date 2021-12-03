public class ViableCallable3 {
  public interface Func {
    int get();
  }

  private Func fun;

  void g() {
    Func f1 = () -> 1;
    Func f2 = new Func() { @Override public int get() { return 2; } };
    fun = (2 > 1 ? f1 : null);
    h(f2);
  }

  void h(Func... f) {
    int x;
    x = fun.get();
    x = f[0].get();
  }
}
