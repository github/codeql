class Foo extends string {
  Foo() { this = "Foo" }
}

predicate test(Foo f) { f.(Foo).toString() = "X" }

predicate test2(Foo a, Foo b) { a.(Foo) = b }

predicate called(Foo a) { a.toString() = "X" }

predicate test3(string s) { called(s.(Foo)) }
