import ql

class Foo extends string {
  Foo() { this = "hello" }

  string getBar() { result = "bar" }

  string getBarWithThis() { result = this.getBar() }

  string getBarWithoutThis() { result = getBar() }
}
