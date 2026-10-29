public class A {
  void f() {
    Object o = new Object();
    if (o == null) { } // $ Alert // Useless check
    if (o != null) { } // $ Alert // Useless check
    try {
      new Object();
    } catch(Exception e) {
      if (e == null) { // $ Alert // Useless check
        throw new Error();
      }
    }
  }

  void g(Object o) {
    if (o instanceof A) {
      A a = (A)o;
      if (a != null) { // $ Alert // Useless check
        throw new Error();
      }
    }
  }

  interface I {
    A get();
  }

  I h() {
    final A x = this;
    return () -> {
      if (x != null) { // $ Alert // Useless check
        return x;
      }
      return new A();
    };
  }

  Object f2(Object x) {
    if (x == null) {
      return this != null ? this : null; // $ Alert // Useless check
    }
    if (x != null) { // $ Alert // Useless check
      return x;
    }
    return null;
  }

  private final Object finalObj = new Object();

  public void ex12() {
    finalObj.hashCode();
    if (finalObj != null) { // $ Alert // Useless check
      finalObj.hashCode();
    }
  }
}
