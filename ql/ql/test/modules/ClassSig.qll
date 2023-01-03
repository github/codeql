signature class FooSig;

class FooImpl extends string {
  FooImpl() { this = "FooImpl" }
}

module Bar<FooSig Foo> { }

module Scope {
  import Bar<FooImpl>

  class Foo extends int {
    Foo() { this = 1 }
  }

  predicate fooTest(Foo f) { none() }
}
