import ql

class Foo extends string {
  Foo() { this = "hello" }

  string getBar() { result = "bar" }

  /* Okay, because we don't write `this.some_method` anywhere */
  string getBarWithoutThis() { result = getBar() }

  /* Okay, because this is the only way to cast `this`. */
  string useThisWithInlineCast() { result = this.(string).toUpperCase() }
}
