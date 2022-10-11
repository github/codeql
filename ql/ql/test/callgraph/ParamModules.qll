module PredicateSig {
  signature predicate fooSig(int i);

  module UsesFoo<fooSig/1 fooImpl> {
    predicate bar(int i) { fooImpl(i + 1) }
  }

  predicate myFoo(int i) { i = 42 }

  predicate use(int i) { UsesFoo<myFoo/1>::bar(i) }
}

module ClassSig {
  signature class FooSig extends int;

  module UsesFoo<FooSig FooImpl> {
    FooImpl getAnEven() { result % 2 = 0 }
  }

  class MyFoo extends int {
    MyFoo() { this = [0 .. 10] }

    string myFoo() { result = "myFoo" }
  }

  string use() { result = UsesFoo<MyFoo>::getAnEven().myFoo() }
}

module ModuleSig {
  signature module FooSig {
    class A;

    A getThing();
  }

  module UsesFoo<FooSig FooImpl> {
    B getThing() { result = FooImpl::getThing() }

    class B = FooImpl::A;
  }

  module MyFoo implements FooSig {
    class C extends int {
      C() { this = [0 .. 10] }

      string myFoo() { result = "myFoo" }
    }

    class A = C;

    C getThing() { any() }
  }

  module ImplStuff {
    module Inst = UsesFoo<MyFoo>;

    class D = Inst::B;

    string use1() { result = Inst::getThing().myFoo() }

    string use2(Inst::B b) { result = b.myFoo() }
  }
}
