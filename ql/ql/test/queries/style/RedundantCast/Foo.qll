class Foo extends string {
  Foo() { this = "Foo" }
}

predicate test(Foo f) { f.(Foo).toString() = "X" } // $ Alert

predicate test2(Foo a, Foo b) { a.(Foo) = b } // $ Alert

predicate called(Foo a) { a.toString() = "X" }

predicate test3(string s) { called(s.(Foo)) } // $ Alert
