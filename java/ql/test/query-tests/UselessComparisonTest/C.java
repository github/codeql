public class C {
  double m1(double x) {
    return (x < 0 || x > 1 || Double.isNaN(x)) ? Double.NaN :
        x == 0 ? 0 : x == 1 ? 1 : 0.5;
  }

  void m2(double x) {
    if (x > 0) {
      double y = 1 - x;
      if (y > 0) { // OK
      }
    }
  }
}
