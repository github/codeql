public class Test {

  public int yield(int x) { return x; }

  public void secondCall() { }

  public int yieldWrapper(int x) { 
    int ret = yield(x); 
    secondCall();
    return ret;
  }

}

// Diagnostic Matches: Erroneous node in tree: (ERROR)
// Diagnostic Matches: In file Test.java:8:15 no end location for JCMethodInvocation : yield(x)
// Diagnostic Matches: 1 errors during annotation processing
// Diagnostic Matches: Unknown or erroneous type for expression of kind ErrorExpr
