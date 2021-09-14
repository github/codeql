public class Test {

  interface Functional {
    int f();
  }

  class Concrete implements Functional {
    public int f() { return 0; }
  }

  interface FunctionalWithDefaults {
    int f();

    default int g() { return 1; }
  }

  interface NotFunctional {
    default int g() { return 1; }
  }

  interface FunctionalWithObjectMethods {
    int f();

    String toString();

    int hashCode();
  }

}
