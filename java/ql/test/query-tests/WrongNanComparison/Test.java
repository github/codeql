class Test {
  void f(double x, float y) {
    if (x == Double.NaN) return; // $ Alert
    if (y == Float.NaN) return; // $ Alert
  }
}
