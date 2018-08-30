public class NamespaceTest {
  /**
   * A namespace class because it only includes static members. It should
   * be live, because it has a live inner class.
   */
  public static class NamespaceClass {
    /**
     * Empty constructor provided to suppress the default public constructor. Should not prevent this
     * from being idenfitied as namespace class.
     */
    protected NamespaceClass() { }

    public static class LiveInnerClass {
    }

    public static boolean deadStaticField = false;

    public static void deadStaticMethod() {
    }
  }

  /**
   * A namespace class that uses enums. It should be live, because it has a live inner class.
   * It extends another namespace class, which is permitted.
   */
  public static class NamespaceEnumClass extends NamespaceClass {
    public static enum LiveInnerClass3 {
    }
  }

  /**
   * This class is not a namespace class, because it has an instance method. The nested live class
   * should not make the NonNamespaceClass live.
   */
  public static class NonNamespaceClass {
    public static class LiveInnerClass2 {
    }

    public boolean deadInstanceField = false;

    public void deadMethod() {
    }
  }

  public static void main(String[] args){
    new NamespaceClass.LiveInnerClass();
    new NonNamespaceClass.LiveInnerClass2();
    NamespaceEnumClass.LiveInnerClass3.values();
  }

}
