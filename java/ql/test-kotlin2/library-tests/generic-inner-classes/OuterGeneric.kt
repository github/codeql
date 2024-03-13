package testuser

public class OuterGeneric<T> {

  public inner class InnerNotGeneric {

    fun identity(t: T): T { return t }

  }

  public inner class InnerGeneric<S> {

    constructor() { }

    constructor(s: S) { }

    fun returnsecond(t: T, s: S): S { return s; }

  }

}

