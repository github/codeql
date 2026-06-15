
// --- stubs ---

// --- tests ---

func sourceInt() -> Int { return 0 }
func sourceUInt() -> UInt { return 0 }
func sink(arg: Any) {}

// ---

enum MyRawRepresentable : RawRepresentable {
  case valueOne
  case valueTwo

	init?(rawValue: Int) {
    switch rawValue {
      case 1: self = .valueOne
      case 2: self = .valueTwo
      default: return nil
    }
  }

  var rawValue: Int {
    switch self {
      case .valueOne: return 1
      case .valueTwo: return 2
    }
  }
}

func testRawRepresentable() {
  let rr1 = MyRawRepresentable.valueOne
  let rr2 = MyRawRepresentable(rawValue: 1)!
  let rr3 = MyRawRepresentable(rawValue: sourceInt())!

  sink(arg: rr1)
  sink(arg: rr2)
  sink(arg: rr3) // $ tainted=35

  sink(arg: rr1.rawValue)
  sink(arg: rr2.rawValue)
  sink(arg: rr3.rawValue) // $ tainted=35
}

// ---

struct MyOptionSet : OptionSet {
	let rawValue: UInt

	static let red = MyOptionSet(rawValue: 1 << 0)
	static let green = MyOptionSet(rawValue: 1 << 1)
	static let blue = MyOptionSet(rawValue: 1 << 2)
}

func testOptionSet() {
	sink(arg: MyOptionSet.red)
	sink(arg: MyOptionSet([.red, .green]))
	sink(arg: MyOptionSet(rawValue: 0))
	sink(arg: MyOptionSet(rawValue: sourceUInt())) // $ tainted=60

	sink(arg: MyOptionSet.red.rawValue)
	sink(arg: MyOptionSet([.red, .green]).rawValue)
	sink(arg: MyOptionSet(rawValue: 0).rawValue)
	sink(arg: MyOptionSet(rawValue: sourceUInt()).rawValue) // $ tainted=65
}
