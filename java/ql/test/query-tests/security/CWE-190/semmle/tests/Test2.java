public class Test2 {
  // IntMultToLong
  void foo() {
    for (int k = 1; k < 10; k++) {
      long res = k * 1000; // OK
    }
  }
}
