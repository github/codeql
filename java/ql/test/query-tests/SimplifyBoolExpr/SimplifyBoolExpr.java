class Test {
  void f(boolean x, boolean y, Boolean a, Boolean b) {
    boolean w;
    w = a == false;
    w = x != true;
    w = a ? false : b;
    w = a ? true : false;
    w = x ? y : true;
  }
  void g(int x, int y) {
    boolean w;
    w = !(x > y);
    w = !(x != y);
  }
  public Boolean getBool(int i) {
    if (i > 2)
      return i == 3 ? true : null; // ok; expression can't be simplified
    return i == 1 ? false : null; // ok; expression can't be simplified
  }
  public Boolean getBoolNPE(int i) {
    if (i > 2)
      return i == 3 ? true : ((Boolean)null); // should be reported; both this and the simplified version have equal NPE behavior
    return i == 1 ? false : ((Boolean)null); // should be reported; both this and the simplified version have equal NPE behavior
  }
}
