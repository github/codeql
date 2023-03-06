
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

  sink(arg: 1 &+ source()) // $ tainted=27
  sink(arg: source() &+ 1) // $ tainted=28
  sink(arg: 1 &- source()) // $ tainted=29
  sink(arg: source() &- 1) // $ tainted=30
  sink(arg: 2 &* source()) // $ tainted=31
  sink(arg: source() &* 2) // $ tainted=32
}

func taintThroughAssignmentArithmetic() {
  var a = 0
  sink(arg: a)
  a += 1
  sink(arg: a)
  a += source()
  sink(arg: a) // $ tainted=40
  a += 1
  sink(arg: a) // $ tainted=40
  a = 0
  sink(arg: a)

  var b = 128
  b -= source()
  sink(arg: b) // $ tainted=48
  b -= 1
  sink(arg: b) // $ tainted=48

  var c = 10
  c *= source()
  sink(arg: c) // $ tainted=54
  c *= 2
  sink(arg: c) // $ tainted=54

  var d = 100
  d /= source()
  sink(arg: d) // $ tainted=60
  d /= 2
  sink(arg: d) // $ tainted=60

  var e = 1000
  e %= source()
  sink(arg: e) // $ tainted=66
  e %= 100
  sink(arg: e) // $ tainted=66
}

func taintThroughBitwiseOperators() {
  sink(arg: 0 | source()) // $ tainted=73
  sink(arg: source() | 0) // $ tainted=74

  sink(arg: 0xffff & source()) // $ tainted=76
  sink(arg: source() & 0xffff) // $ tainted=77

  sink(arg: 0xffff ^ source()) // $ tainted=79
  sink(arg: source() ^ 0xffff) // $ tainted=80

  sink(arg: source() << 1) // $ tainted=82
  sink(arg: source() &<< 1) // $ tainted=83
  sink(arg: source() >> 1) // $ tainted=84
  sink(arg: source() &>> 1) // $ tainted=85

  sink(arg: ~source()) // $ tainted=87
}
