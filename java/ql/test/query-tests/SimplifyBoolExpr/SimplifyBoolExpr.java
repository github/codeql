class Test {
  void f(boolean x, boolean y, Boolean a, Boolean b) {
    boolean w;
    w = a == false; // $ Alert
    w = x != true; // $ Alert
    w = a ? false : b; // $ Alert
    w = a ? true : false; // $ Alert
    w = x ? y : true; // $ Alert
  }
  void g(int x, int y) {
    boolean w;
    w = !(x > y); // $ Alert
    w = !(x != y); // $ Alert
  }
  public Boolean getBool(int i) {
    if (i > 2)
      return i == 3 ? true : null; // ok; expression can't be simplified
    return i == 1 ? false : null; // ok; expression can't be simplified
  }
  public Boolean getBoolNPE(int i) {
    if (i > 2)
      return i == 3 ? true : ((Boolean)null); // $ Alert // should be reported; both this and the simplified version have equal NPE behavior
    return i == 1 ? false : ((Boolean)null); // $ Alert // should be reported; both this and the simplified version have equal NPE behavior
  }
}
