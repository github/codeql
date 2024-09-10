package extlib;

public class OuterManyParams<A, B> {

  public OuterManyParams(A a, B b) { }

  public class MiddleManyParams<C, D> {

    public MiddleManyParams(C c, D d) { }

    public class InnerManyParams<E, F> {

      public InnerManyParams(E e, F f) { }

      public F returnSixth(A a, B b, C c, D d, E e, F f) { return f; }

    }

  }

}

