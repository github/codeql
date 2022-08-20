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

    // Not actually abstract; implementation comes from Object
    boolean equals(Object obj);
    int hashCode();
    String toString();
  }

  interface NotFunctionalWithObjectMethods {
    int f();

    // Increases their visibility from `protected` to `public`; this requires subclasses to implement them
    // See also JLS section "Functional Interfaces" which explicitly covers this
    Object clone();
    void finalize();
  }

}
