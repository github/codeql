package extlib;

public class OuterGeneric<T> {

  public class InnerNotGeneric {

    public T identity(T t) { return t; }

  }

  public InnerNotGeneric getInnerNotGeneric() { return null; }

  public class InnerGeneric<S> {

    public <R> InnerGeneric(R r) { }

    public <R> InnerGeneric(R r, S s) { }

    public S returnsecond(T t, S s) { return s; }

    public <R> S returnsecond(T t, S s, R r) { return s; }

  }

  public static class InnerStaticGeneric<S> {

    public <R> InnerStaticGeneric(R r, S s) { }

    public S identity(S s) { return s; }

  }

}

