public class Test {

  void inheritMe() { }

}

interface ParentIf {

  void inheritedInterfaceMethodJ();

}

interface ChildIf extends ParentIf {


}

class Child extends Test {

  public static void user() {

    Child c = new Child();
    c.toString();
    c.equals(c);
    c.hashCode();
    c.inheritMe();
    ChildIf c2 = null;
    c2.inheritedInterfaceMethodJ();

  }

}

