import ql

class Foo extends string {
  Foo() { this = "hello" }

  string getBar() { result = "bar" }

  string getBarWithThis() { result = this.getBar() }

  /* Okay because not a member predicate. */
  string getBaz() { result = Baz::baz() }

  /* Okay because not a member predicate. */
  string getOuterQuux() { result = getQuux() }
}

string getQuux() { result = "quux" }

module Baz {
  string baz() { result = "baz" }
}
