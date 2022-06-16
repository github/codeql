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
  // TODO:
}
