
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

// --- globals and class member variables ---

let g1 = source()
let g2 = source() + 1
let g3 = g1
var gv = source()

class MyClass {
	let m1 = source()
	let m2 = source() + 1
	let m3 = g1
	var mv = source()

	static let s1 = source()
	static let s2 = source() + 1
	static let s3 = s1
	static var sv = source()

	func test() {
		sink(arg: g1) // $ MISSING: tainted=92
		sink(arg: g2) // $ MISSING: tainted=93
		sink(arg: g3) // $ MISSING: tainted=94
		sink(arg: gv)
		gv = 0
		sink(arg: gv)

		sink(arg: m1) // $ MISSING: tainted=98
		sink(arg: m2) // $ MISSING: tainted=99
		sink(arg: m3) // $ MISSING: tainted=100
		sink(arg: mv)
		mv = 0
		sink(arg: mv)

		sink(arg: MyClass.s1) // $ MISSING: tainted=103
		sink(arg: MyClass.s2) // $ MISSING: tainted=104
		sink(arg: MyClass.s3) // $ MISSING: tainted=105
		sink(arg: MyClass.sv)
		MyClass.sv = 0
		sink(arg: MyClass.sv)
	}
}

func test_instantiate_MyClass() {
  let mc = MyClass()

  mc.test()

  sink(arg: g1) // $ MISSING: tainted=92
  sink(arg: mc.m1) // $ MISSING: tainted=98
  sink(arg: MyClass.s1) // $ MISSING: tainted=103
}

class MyClass2_NeverInstantiated {
	let m1 = source()
	static let s1 = source()

	func test() {
		sink(arg: g1) // $ MISSING: tainted=92
		sink(arg: m1) // $ MISSING: tainted=143
		sink(arg: MyClass2_NeverInstantiated.s1) // $ MISSING: tainted=144
  }
}

// ---

func taintThroughAs() {
	sink(arg: source() as Int) // $ tainted=156
	sink(arg: source() as Any) // $ tainted=157
	sink(arg: source() as AnyObject) // $ MISSING: tainted=158
	sink(arg: source() as Sendable) // $ MISSING: tainted=159
}
