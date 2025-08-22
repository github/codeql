class Generic2<T> { 

  public Generic2(T init) { stored = init; }

  private T stored;

  T identity2(T param) { return identity(param); }
  T identity(T param) { return param; }
  T getter() { return stored; }
  void setter(T param) { stored = param; }

}

public class Test {

  public static void user() {

    Generic2<String> invariant = new Generic2<String>("hello world");
    invariant.identity("hello world");
    invariant.identity2("hello world");

    Generic2<? extends String> projectedOut = invariant;
    projectedOut.getter();

    Generic2<? super String> projectedIn = invariant;
    projectedIn.setter("hi planet");
    projectedIn.getter();

  }

}


