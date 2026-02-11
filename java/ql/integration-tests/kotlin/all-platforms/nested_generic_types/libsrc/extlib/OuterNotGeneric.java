package extlib;

public class OuterNotGeneric {

  public class InnerGeneric<S> {

    public S identity(S s) { return s; }

  }

  public InnerGeneric<String> getInnerGeneric() {

    return new InnerGeneric<String>();

  }

}
