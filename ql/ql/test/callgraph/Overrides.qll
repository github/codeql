import ql

class Foo extends int {
  Foo() { this in [1, 2, 3] }

  int bar() { result = this }

  predicate baz(int i) { i = this.bar() }
}

class Bar extends Foo {
  Bar() { this = [1, 2] }

  override int bar() { result = 10 * this }

  override predicate baz(int i) { i = this.bar() }
}

class Baz extends Foo {
  Baz() { this = 1 }

  override int bar() { result = 100 * this }

  override predicate baz(int i) { i = this.bar() }
}

query predicate test(Foo f, int i, int j) {
  f.bar() = i and
  f.baz(j)
}
