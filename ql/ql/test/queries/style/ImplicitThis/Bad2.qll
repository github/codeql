import ql

class Foo extends string {
  Foo() { this = "hello" }

  string getBar() { result = "bar" }

  string getBarWithoutThis() { result = getBar() }
}
