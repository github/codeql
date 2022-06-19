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
