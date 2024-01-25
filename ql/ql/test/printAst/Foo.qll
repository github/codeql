import javascript

class Foo extends @bar {
  Foo() { 1 = 2 }

  string toString() { result = "Foo" }
}

query predicate foo(Foo f) {
  f = rank[2](Foo inner | inner.toString() = "foo" | inner order by inner.toString())
}

predicate calls(Foo f) {
  calls(f)
  or
  "foo" = f.toString(1, 2, 3)
  or
  f.(Foo).toString() = "bar"
  or
  f.(Foo) = f
  or
  f = any(Foo f)
  or
  2 = 1 + (2 + (3 + 4))
  or
  true = false
}

newtype TPathNode = TPathNodeMid()

private newtype TPathNode2 =
  TPathNodeMid2(boolean foo) { foo = true } or
  TPathNodeSink(string bar) { bar = "bar" }
