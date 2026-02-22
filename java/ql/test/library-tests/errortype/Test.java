import nosuchpackage.NoSuchClass;

public class Test {

  public NoSuchClass test() {
    NoSuchClass nsc = new NoSuchClass();
    return nsc;
  }

  static class GenericClass<T> {
    public void method() { }
  }

  public void testDispatch() {
    GenericClass<String> g1 = new GenericClass<>();
    g1.method();
    GenericClass<NoSuchClass> g2 = new GenericClass<>();
    g2.method();
  }
}

// Diagnostic Matches: Unexpected symbol for constructor: new NoSuchClass()
// Diagnostic Matches: 2 javac errors
// Diagnostic Matches: 2 errors during annotation processing
// Diagnostic Matches: Unknown or erroneous type for expression of kind TypeAccess
// Diagnostic Matches: Unknown or erroneous type for expression of kind ClassInstanceCreation
// Diagnostic Matches: Unknown or erroneous type for expression of kind VarAccess
