import ql

class Foo extends string {
  Foo() { this = "hello" }

  string getBar() { result = "bar" }

  /* Okay, because this is the only way to cast `this`. */
  string useThisWithInlineCast() { result = this.(string).toUpperCase() }
}
