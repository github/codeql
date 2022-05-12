package testuser

public class OuterNotGeneric {

  public inner class InnerGeneric<S> {

    fun identity(s: S): S { return s }

  }

}
