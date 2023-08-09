
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
	sink(arg: Int(sourceInt())) // $ MISSING: tainted=
	sink(arg: UInt8(sourceInt())) // $ MISSING: tainted=
	sink(arg: Float(sourceInt())) // $ MISSING: tainted=
	sink(arg: String(sourceInt())) // $ tainted=28
	sink(arg: String(sourceInt()).utf8) // $ tainted=29
	sink(arg: [UInt8](sourceString().utf8)) // $ MISSING: tainted=

	if let v = sourceInt() as? UInt {
		sink(arg: v) // $ MISSING: tainted=
	}

	let v2: UInt8 = numericCast(sourceInt())
	sink(arg: v2) // $ MISSING: tainted=

	let v4: UInt = unsafeBitCast(sourceInt(), to: UInt.self)
	sink(arg: v4) // $ MISSING: tainted=

	let v5 = UInt(truncatingIfNeeded: sourceInt())
	sink(arg: v5) // $ MISSING: tainted=

	let v6 = UInt(bitPattern: sourceInt())
	sink(arg: v6) // $ MISSING: tainted=

	sink(arg: Int(exactly: sourceInt())!) // $ MISSING: tainted=
	sink(arg: Int(clamping: sourceInt())) // $ MISSING: tainted=
	sink(arg: Int(truncatingIfNeeded: sourceInt())) // $ MISSING: tainted=
	sink(arg: Int(sourceString(), radix: 10)!) // $ MISSING: tainted=

	sink(arg: Int(littleEndian: sourceInt())) // $ MISSING: tainted=
	sink(arg: Int(bigEndian: sourceInt())) // $ MISSING: tainted=
	sink(arg: sourceInt().littleEndian) // $ MISSING: tainted=
	sink(arg: sourceInt().bigEndian) // $ MISSING: tainted=

	// ---

	sink(arg: sourceFloat()) // $ tainted=60
	sink(arg: Float(sourceFloat())) // $ MISSING: tainted=
	sink(arg: UInt8(sourceFloat())) // $ MISSING: tainted=
	sink(arg: String(sourceFloat())) // $ tainted=63
	sink(arg: String(sourceFloat()).utf8) // $ tainted=64

	sink(arg: Float(sourceFloat())) // MISSING: tainted=
	sink(arg: Float(sign: .plus, exponent: sourceInt(), significand: 0.0)) // MISSING: tainted=
	sink(arg: Float(sign: .plus, exponent: 0, significand: sourceFloat())) // MISSING: tainted=
	sink(arg: Float(signOf: sourceFloat(), magnitudeOf: 0.0)) // (good)
	sink(arg: Float(signOf: 0.0, magnitudeOf: sourceFloat())) // MISSING: tainted=

	sink(arg: sourceFloat().exponent) // $ MISSING: tainted=
	sink(arg: sourceFloat().significand) // $ MISSING: tainted=

	// ---

	sink(arg: sourceString()) // $ tainted=77
	sink(arg: String(sourceString())) // $ tainted=78

	let ms1 = MyString("abc")!
	sink(arg: ms1)
	sink(arg: ms1.description)
	sink(arg: ms1.debugDescription)
	sink(arg: ms1.clean)

	let ms2 = MyString(sourceString())!
	sink(arg: ms2) // $ MISSING: tainted=
	sink(arg: ms2.description) // $ MISSING: tainted=
	sink(arg: ms2.debugDescription) // $ MISSING: tainted=
	sink(arg: ms2.clean)

	// ---

	let parent : MyParentClass = sourceString() as! MyChildClass
	sink(arg: parent) // $ tainted=94
	sink(arg: parent as! MyChildClass) // $ tainted=94

	let v3: MyChildClass = unsafeDowncast(parent, to: MyChildClass.self)
	sink(arg: v3) // $ MISSING: tainted=
	sink(arg: v3 as! MyParentClass) // $ MISSING: tainted=
}
