import ql

predicate foo() { none() }

query predicate test() { foo() }

class Foo extends AstNode {
  predicate bar() { none() }

  predicate baz() { bar() }
}

class Sub extends Foo {
  override predicate baz() { super.baz() }
}

query predicate test2() { any(Foo f).bar() }

module Aliases {
  predicate myThing2(int i, int j) { i = 2 and j = 3 }

  predicate myThing0() { any() }

  predicate alias0 = myThing0/0;

  predicate alias2 = myThing2/2;

  query predicate test3() {
    alias2(3, 4) // doesn't work.
    or
    alias0() // <- works
  }
}

module Buildins {
  predicate replaceAll(string s) { "foo".replaceAll("foo", "bar") = s }

  predicate regexpCapture(string s) { "foo".regexpCapture("\\w", 1) = s }
}

cached
newtype TApiNode = MkRoot()

private predicate edge(TApiNode a, TApiNode b) { a = b }

cached
int distanceFromRoot(TApiNode nd) = shortestDistances(MkRoot/0, edge/2)(_, nd, result)
