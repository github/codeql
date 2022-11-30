public class GenericTest<T> {

  void f() { }

}

class Outer2 {

  void f() { }

  class Inner<T> extends GenericTest<T> {

    public void test() {
      f();
    }

  }

}
