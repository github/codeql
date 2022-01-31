import ql

module Firebase {
  module Database {
    query predicate ref(int i) { i = snapshot() }
  }

  int snapshot() { result = 2 }
}

class Foo extends int {
  Foo() { this = 1 or this = 2 }
}

class Function extends int {
  Function() { this = 1 }

  bindingset[i]
  int getParameter(int i) { result = i * this }
}

class Bar extends Foo instanceof Function {
  Bar() {
    exists(super.getParameter(0))
    or
    exists(this.getParameter(0)) // <- we support this, until it's clear whether it's a compile error or not
  }

  predicate bar() {
    exists(super.getParameter(0))
    // or
    // exists(this.getParameter(0)) // <- this is definitely a compile error
  }
}
