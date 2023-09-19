import nosuchpackage.NoSuchClass;

public class Test {

  public NoSuchClass test() {
    NoSuchClass nsc = new NoSuchClass();
    return nsc;
  }

}

// Diagnostic Matches: Unexpected symbol for constructor: new NoSuchClass()
// Diagnostic Matches: 2 javac errors
// Diagnostic Matches: 2 errors during annotation processing
