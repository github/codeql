func clean() -> String { return ""; }
func source() -> String { return ""; }
func sink(arg: String) {}

class MyStringPair {
	var first: String = ""
	var second: String = ""
}

extension String.StringInterpolation {
	mutating func appendInterpolation(_ pair: MyStringPair) {
		// for MyStringPair, string interpolation outputs just the `first` value.
		appendInterpolation("first is: \(pair.first)")
	}
}

func taintThroughCustomStringInterpolation() {
	let p1 = MyStringPair()
	p1.first = source()
	p1.second = clean()

	sink(arg: "pair: \(p1.first)") // $ tainted=19
	sink(arg: "pair: \(p1.second)")
	sink(arg: "pair: \(p1)") // $ tainted=19

	let p2 = MyStringPair()
	p2.first = clean()
	p2.second = source()

	sink(arg: "pair: \(p2.first)")
	sink(arg: "pair: \(p2.second)") // $ tainted=28
	sink(arg: "pair: \(p2)")
}

func moreTestsStringInterpolation() {
	let a = source()
	let b = clean()
	let c = clean()

	sink(arg: "\(a) and \(a)") // $ tainted=36
	sink(arg: "\(a) and \(b)") // $ tainted=36
	sink(arg: "\(b) and \(a)") // $ tainted=36
	sink(arg: "\(b) and \(b)")
	sink(arg: "\(c) and \(c)")
}
