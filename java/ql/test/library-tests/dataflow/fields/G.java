public class G {
  static Object[] f;

  void sink(Object o) { }

  void runsink() {
    sink(f[0]);
  }

  void test1() {
    f[0] = new Object();
  }

  void test2() {
    addObj(f);
  }

  void addObj(Object[] xs) {
    xs[0] = new Object();
  }
}
