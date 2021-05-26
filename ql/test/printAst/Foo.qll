import javascript

class Foo extends @bar {
  Foo() { 1 = 2 }

  string toString() { result = "Foo" }
}

query predicate foo(Foo f) {
  f = rank[2](Foo inner | inner.toString() = "foo" | inner order by inner.toString())
}
