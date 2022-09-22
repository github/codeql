public class Test {

  void f() { }

}

class Outer {

  void f() { }

  class Inner extends Test {

    public void test() {
      f();
    }

  }

}
