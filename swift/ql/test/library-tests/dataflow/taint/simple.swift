
// --- stubs ---

// --- tests ---

func source() -> Int { return 0; }
func sink(arg: Any) {}

func taintThroughArithmetic() {
  // arithmetic

  sink(arg: 1 + source()) // $ tainted=12
  sink(arg: source() + 1) // $ tainted=13
  sink(arg: 1 - source()) // $ tainted=14
  sink(arg: source() - 1) // $ tainted=15
  sink(arg: 2 * source()) // $ tainted=16
  sink(arg: source() * 2) // $ tainted=17
  sink(arg: 100 / source()) // $ tainted=18
  sink(arg: source() / 100) // $ tainted=19
  sink(arg: 100 % source()) // $ tainted=20
  sink(arg: source() % 100) // $ tainted=21

  sink(arg: -source()) // $ tainted=23

  // overflow operators

  sink(arg: 1 &+ source()) // $ MISSING: tainted=
  sink(arg: source() &+ 1) // $ MISSING: tainted=
  sink(arg: 1 &- source()) // $ MISSING: tainted=
  sink(arg: source() &- 1) // $ MISSING: tainted=
  sink(arg: 2 &* source()) // $ MISSING: tainted=
  sink(arg: source() &* 2) // $ MISSING: tainted=
}

func taintThroughAssignmentArithmetic() {
  var a = 0
  sink(arg: a)
  a += 1
  sink(arg: a)
  a += source()
  sink(arg: a) // $ MISSING: tainted=
  a += 1
  sink(arg: a) // $ MISSING: tainted=
  a = 0
  sink(arg: a)

  var b = 128
  b -= source()
  sink(arg: b) // $ MISSING: tainted=
  b -= 1
  sink(arg: b) // $ MISSING: tainted=

  var c = 10
  c *= source()
  sink(arg: c) // $ MISSING: tainted=
  c *= 2
  sink(arg: c) // $ MISSING: tainted=

  var d = 100
  d /= source()
  sink(arg: d) // $ MISSING: tainted=
  d /= 2
  sink(arg: d) // $ MISSING: tainted=

  var e = 1000
  e %= source()
  sink(arg: e) // $ MISSING: tainted=
  e %= 100
  sink(arg: e) // $ MISSING: tainted=
}
