module Test1 {
  class Foo extends int {
    Foo() { this = 1 }

    Foo pred() { result = this }
  }

  class Bar extends Foo {
    override Foo pred() { result = Foo.super.pred() } // BAD
  }
}

module Test2 {
  class Foo extends int {
    Foo() { this = 1 }

    Foo pred() { result = this }
  }

  class Bar extends Foo {
    override Foo pred() { result = super.pred() } // BAD
  }
}

module Test3 {
  class Foo extends int {
    Foo() { this = [1 .. 3] }

    Foo pred() { any() }
  }

  class Bar extends Foo {
    Bar() { this = 2 }
  }

  class Baz extends Foo {
    Baz() { this = 3 }

    override Bar pred() { result = super.pred() } // GOOD (refined return type)
  }
}

module Test4 {
  class Foo extends int {
    Foo() { this = [1, 2] }

    Foo pred() { result = 2 }
  }

  class Bar extends Foo {
    Bar() { this = 1 }

    override Foo pred() { result = this } // GOOD
  }
}

module Test5 {
  class Foo extends int {
    Foo() { this = 1 }

    Foo pred() { result = this }
  }

  class Bar extends Foo {
    /** My own overriding QL doc. */
    override Foo pred() { result = super.pred() } // GOOD
  }
}

module Test6 {
  class Foo extends int {
    Foo() { this = [1, 2] }

    Foo pred() { result = 1 }

    Foo pred2() { result = 2 }
  }

  class Bar extends Foo {
    override Foo pred() { result = super.pred2() } // GOOD
  }
}

module Test7 {
  class Foo extends int {
    Foo() { this = [1, 2] }

    Foo pred() { result = 2 }
  }

  class Bar extends int {
    Bar() { this = 1 }

    Foo pred() { result = this }
  }

  class Baz extends Foo, Bar {
    override Foo pred() { result = Foo.super.pred() } // GOOD (disambiguate)
  }
}

module Test8 {
  class Foo extends int {
    Foo() { this = 1 }

    predicate pred(Foo f) { f = this }
  }

  class Bar extends Foo {
    override predicate pred(Foo f) { super.pred(f) } // BAD
  }
}

module Test9 {
  class Foo extends int {
    Foo() { this = [1, 2] }

    Foo pred() { result = this }
  }

  class Bar extends Foo {
    Bar() { this = 1 }

    override Foo pred() { Foo.super.pred() = result } // BAD
  }

  class Baz1 extends Foo, Bar {
    override Foo pred() { Foo.super.pred() = result } // BAD
  }

  class Baz2 extends Foo, Baz1 {
    override Foo pred() { Baz1.super.pred() = result } // BAD
  }
}

module Test10 {
  class Foo extends int {
    Foo() { this = [1, 2] }

    Foo pred() { result = 1 }
  }

  class Bar extends int {
    Bar() { this = 1 }

    Foo pred(int i) { none() }
  }

  class Baz1 extends Foo, Bar {
    override Foo pred() { result = Foo.super.pred() } // BAD
  }
}

module Test11 {
  class Foo extends int {
    Foo() { this = [1 .. 4] }

    Foo pred() { result = 1 }
  }

  class Bar1 extends Foo {
    Bar1() { this = [1 .. 3] }

    override Foo pred() { Foo.super.pred() = result } // BAD
  }

  class Bar2 extends Foo, Bar1 {
    override Foo pred() { Foo.super.pred() = result } // BAD
  }

  class Bar3 extends Foo, Bar2 {
    override Foo pred() { Bar2.super.pred() = result } // BAD
  }

  class Bar4 extends Bar2, Bar3 {
    override Foo pred() { result = Bar2.super.pred() } // BAD
  }

  class Bar5 extends Foo {
    Bar5() { this = [1 .. 2] }

    override Foo pred() { result = this } // GOOD
  }

  class Bar6 extends Bar4, Bar5 {
    override Foo pred() { result = Bar4.super.pred() } // GOOD (dismambiguate)
  }

  class Bar7 extends Bar6 {
    Bar7() { this = 1 }

    override Foo pred() { result = 2 } // GOOD
  }

  class Bar8 extends Bar6, Bar7 {
    override Foo pred() { result = Bar6.super.pred() } // GOOD (specialize)
  }
}
