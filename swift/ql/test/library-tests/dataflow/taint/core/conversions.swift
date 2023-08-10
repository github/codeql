
func sourceInt() -> Int { 0 }
func sourceFloat() -> Float { 0.0 }
func sourceString() -> String { "" }
func sink(arg: Any) { }

// ---

class MyParentClass {
}

class MyChildClass : MyParentClass {
}

class MyString : LosslessStringConvertible, CustomStringConvertible, CustomDebugStringConvertible {
	required init?(_ description: String) { }

	var description: String { get { return "" } }
	var debugDescription: String { get { return "" } }
	var clean: String { get { return "" } }
}

func testConversions() {
	sink(arg: sourceInt()) // $ tainted=24
	sink(arg: Int(sourceInt())) // $ tainted=25
	sink(arg: UInt8(sourceInt())) // $ tainted=26
	sink(arg: Float(sourceInt())) // $ tainted=27
	sink(arg: String(sourceInt())) // $ tainted=28
	sink(arg: String(sourceInt()).utf8) // $ tainted=29
	sink(arg: [UInt8](sourceString().utf8)) // $ MISSING: tainted=

	if let v = sourceInt() as? UInt {
		sink(arg: v) // $ tainted=32
	}

	let v2: UInt8 = numericCast(sourceInt())
	sink(arg: v2) // $ tainted=36

	let v4: UInt = unsafeBitCast(sourceInt(), to: UInt.self)
	sink(arg: v4) // $ tainted=39

	let v5 = UInt(truncatingIfNeeded: sourceInt())
	sink(arg: v5) // $ tainted=42

	let v6 = UInt(bitPattern: sourceInt())
	sink(arg: v6) // $ tainted=45

	sink(arg: Int(exactly: sourceInt())!) // $ tainted=48
	sink(arg: Int(clamping: sourceInt())) // $ tainted=49
	sink(arg: Int(truncatingIfNeeded: sourceInt())) // $ tainted=50
	sink(arg: Int(sourceString(), radix: 10)!) // $ tainted=51

	sink(arg: Int(littleEndian: sourceInt())) // $ tainted=53
	sink(arg: Int(bigEndian: sourceInt())) // $ tainted=54
	sink(arg: sourceInt().littleEndian) // $ tainted=55
	sink(arg: sourceInt().bigEndian) // $ tainted=56

	// ---

	sink(arg: sourceFloat()) // $ tainted=60
	sink(arg: Float(sourceFloat())) // $ tainted=61
	sink(arg: UInt8(sourceFloat())) // $ tainted=62
	sink(arg: String(sourceFloat())) // $ tainted=63
	sink(arg: String(sourceFloat()).utf8) // $ tainted=64

	sink(arg: Float(sourceFloat())) // $ tainted=66
	sink(arg: Float(sign: .plus, exponent: sourceInt(), significand: 0.0)) // $ tainted=67
	sink(arg: Float(sign: .plus, exponent: 0, significand: sourceFloat())) // $ tainted=68
	sink(arg: Float(signOf: sourceFloat(), magnitudeOf: 0.0)) // (good)
	sink(arg: Float(signOf: 0.0, magnitudeOf: sourceFloat())) // $ tainted=70

	sink(arg: sourceFloat().exponent) // $ tainted=72
	sink(arg: sourceFloat().significand) // $ tainted=73

	// ---

	sink(arg: sourceString()) // $ tainted=77
	sink(arg: String(sourceString())) // $ tainted=78

	let ms1 = MyString("abc")!
	sink(arg: ms1)
	sink(arg: ms1.description)
	sink(arg: ms1.debugDescription)
	sink(arg: ms1.clean)

	let ms2 = MyString(sourceString())!
	sink(arg: ms2) // $ tainted=86
	sink(arg: ms2.description) // $ MISSING: tainted=
	sink(arg: ms2.debugDescription) // $ MISSING: tainted=
	sink(arg: ms2.clean)

	// ---

	let parent : MyParentClass = sourceString() as! MyChildClass
	sink(arg: parent) // $ tainted=94
	sink(arg: parent as! MyChildClass) // $ tainted=94

	let v3: MyChildClass = unsafeDowncast(parent, to: MyChildClass.self)
	sink(arg: v3) // $ tainted=94
	sink(arg: v3 as! MyParentClass) // $ tainted=94
}

var myCEnumConst : Int = 0
typealias MyCEnumType = UInt32

func testCEnum() {
	sink(arg: MyCEnumType(myCEnumConst))
	sink(arg: MyCEnumType(sourceInt())) // $ tainted=108
}
