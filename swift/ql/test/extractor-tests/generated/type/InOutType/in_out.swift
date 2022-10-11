func foo(_: inout Int) {}

var x: Int = 42

foo(&x)

struct S {
  mutating func bar() {}
}

var s: S = S()
s.bar()
