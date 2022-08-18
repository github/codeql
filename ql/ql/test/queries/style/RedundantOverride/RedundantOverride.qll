class Foo extends string {
  Foo() { this = "Foo" }

  Foo pred() { none() }

  Foo pred2() { none() }

  predicate pred3() { none() }
}

class Bar1 extends Foo {
  override Foo pred() { result = Foo.super.pred() } // BAD
}

class Bar2 extends Foo {
  override Foo pred() { result = super.pred() } // BAD
}

class Bar3 extends Foo {
  override Bar3 pred() { result = super.pred() } // GOOD (refined return type)
}

class Bar4 extends Foo {
  override Foo pred() { any() } // GOOD
}

class Bar5 extends Foo {
  /** My own overriding QL doc. */
  override Foo pred() { result = super.pred() } // GOOD
}

class Bar6 extends Foo {
  override Foo pred() { result = super.pred2() } // GOOD
}

class Bar7 extends string {
  Bar7() { this = "Bar7" }

  Foo pred() { any() }
}

class Bar8 extends Foo, Bar7 {
  override Foo pred() { result = Foo.super.pred() } // GOOD
}

class Bar9 extends Foo {
  override predicate pred3() { super.pred3() } // BAD
}

class Bar10 extends Foo {
  override Foo pred() { Foo.super.pred() = result } // BAD
}
