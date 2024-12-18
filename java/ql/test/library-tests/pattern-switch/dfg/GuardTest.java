public class GuardTest {

  public static void sink(String s) { }
  public static boolean isSafe(String s) { return s.length() < 10; }

  public static void test(Object o) {

    switch (o) {

      case String s:
        sink(s);
        break;
      default:
        break;

    }

    switch (o) {

      case String s when isSafe(s):
        sink(s);
        break;
      default:
        break;

    }

  }

}
