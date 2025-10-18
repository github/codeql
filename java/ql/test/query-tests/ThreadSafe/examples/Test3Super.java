package examples;

@ThreadSafe
public class Test3Super extends Test2 {  // We might want an alert here for the inherited unsafe methods.

  public Test3Super() {
    super.x = 0;
  }

  public void y() {
    super.x = 0;  //$ MISSING: Alert
  }

  public void yLst() {
    super.lst.add("Hello!");  //$ MISSING: Alert
  }
}
