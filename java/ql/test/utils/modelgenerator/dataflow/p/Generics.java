package p;

public class Generics {

  public class Generic1<T> {
    // heuristic-summary=p;Generics$Generic1;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;Generics$Generic1;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;dfc-generated
    public T ReturnParam(T input) {
      return input;
    }

    public T StubImplementation(T input) {
      return null;
    }
  }

  public class DerivedGeneric extends Generic1<String> {
    // heuristic-summary=p;Generics$Generic1;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;Generics$Generic1;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;dfc-generated
    @Override
      public String ReturnParam(String input) {
        return input;
      }

    // heuristic-summary=p;Generics$Generic1;true;StubImplementation;(Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;Generics$Generic1;true;StubImplementation;(Object);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String StubImplementation(String input) {
      return input;
    }
  }

  public class Generic2<T> {
    // heuristic-summary=p;Generics$Generic2;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;Generics$Generic2;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;dfc-generated
    public T ReturnParam(T input) {
      return input;
    }

    public T StubImplementation(T input) {
      return null;
    }
  }

  public class NestedGeneric<T> extends Generic2<String> { }

  public class DerivedNestedGeneric extends NestedGeneric<Integer> {
    // heuristic-summary=p;Generics$Generic2;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;Generics$Generic2;true;ReturnParam;(Object);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String ReturnParam(String input) {
      return input;
    }

    // heuristic-summary=p;Generics$Generic2;true;StubImplementation;(Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=p;Generics$Generic2;true;StubImplementation;(Object);;Argument[0];ReturnValue;value;dfc-generated
    @Override
    public String StubImplementation(String input) {
      return input;
    }
  }
}
