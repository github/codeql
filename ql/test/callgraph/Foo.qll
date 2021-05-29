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
