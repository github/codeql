public class SuppressedConstructorTest {
  private static class SuppressedConstructor {
    // This should not be reported as dead
    private SuppressedConstructor() { }

    public static void liveMethod() { }
  }

  public void deadMethod() {
    new NestedPrivateConstructor();
  }

  private static class NestedPrivateConstructor {
    // This should be dead, because it is called from a dead method.
    private NestedPrivateConstructor() { }

    public static void liveMethod() { }
  }

  private static class OtherConstructor {
    /*
     * This should be marked as dead. There is another constructor declared, so no default
     * constructor will be added by the compiler. Therefore, we do not need to declare this private
     * in order to suppress it.
     */
    private OtherConstructor() { }

    // Live constructor
    private OtherConstructor(Object foo) { }
  }

  public static void main(String[] args) {
    new OtherConstructor(new Object());
    SuppressedConstructor.liveMethod();
    NestedPrivateConstructor.liveMethod();
  }
}
