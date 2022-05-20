public class F {
  public void m1(Object obj) {
    if (obj == null)
      throwMyException();
    obj.hashCode(); // OK
  }

  public void m2(Object obj) {
    if (obj == null)
      doStuff();
    obj.hashCode(); // NPE
  }

  public void m3(Object obj) {
    if (obj == null)
      doStuffOrThrow(0);
    obj.hashCode(); // NPE
  }

  public static class MyException extends RuntimeException {
  }

  public void throwMyException() { // meant to always throw
    throw new MyException();
  }

  public void doStuff() { // meant to be overridden as indicated by UnsupportedOperationException
    throw new UnsupportedOperationException();
  }

  public void doStuffOrThrow(int i) { // meant to be overridden as indicated by unused parameter
    throw new MyException();
  }
}
