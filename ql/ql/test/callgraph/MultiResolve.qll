predicate foo(int a, int b) {
  a = 2 and
  b = 2
}

predicate foo(int a, int b, int c) {
  a = 2 and
  b = 2 and
  c = 2
}

predicate myFoo = foo/2;

predicate test(int i) { myFoo(i, i) } // <- should only resolve to the `foo` with 2 arguments (and the `myFoo` alias).

module MyMod {
  predicate bar() { any() }

  class Bar extends int {
    Bar() { this = 42 }

    predicate bar() {
      MyMod::bar() // <- should resolve to the module's predicate.
    }
  }
}

class Super1 extends int {
  Super1() { this = 42 }

  predicate foo() { any() }
}

class Super2 extends int {
  Super2() { this = 42 }

  predicate foo() { none() }
}

class Sub extends Super1, Super2 {
  override predicate foo() { Super1.super.foo() } // <- should resolve to Super1::foo()
}

module Foo {
  predicate foo() { any() }
}

predicate test() {
  Foo::foo() // <- should resolve to `foo` from the module above, and not from the `Foo.qll` file.
}

class Sub2 extends Super1, Super2 {
  override predicate foo() { Super2.super.foo() } // <- should resolve to Super2::foo()

  predicate test() {
    this.foo() // <- should resolve to only the above `foo` predicate, but currently it resolves to that, and all the overrides [INCONSISTENCY]
  }
}
