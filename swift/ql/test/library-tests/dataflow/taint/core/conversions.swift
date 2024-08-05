
func sourceInt() -> Int { 0 }
func sourceUInt() -> UInt { 0 }
func sourceUInt64() -> UInt64 { 0 }
func sourceFloat() -> Float { 0.0 }
func sourceFloat80() -> Float80 { 0.0 }
func sourceDouble() -> Double { 0.0 }
func sourceString() -> String { "" }
func sourceArray(_ label: String) -> [Int] { [] }

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

typealias MyInt = Int

func testConversions() {
	sink(arg: sourceInt()) // $ tainted=32
	sink(arg: Int(sourceInt())) // $ tainted=33
	sink(arg: UInt8(sourceInt())) // $ tainted=34
	sink(arg: Float(sourceInt())) // $ tainted=35
	sink(arg: String(sourceInt())) // $ tainted=36
	sink(arg: String(sourceInt()).utf8) // $ tainted=37

	let arr = [1, 2, sourceInt()]
	sink(arg: arr) // $ tainted=39
	sink(arg: arr[0]) // $ tainted=39
	sink(arg: [MyInt](arr)) // $ tainted=39
	sink(arg: [MyInt](arr)[0]) // $ tainted=39
	sink(arg: [UInt8](sourceString().utf8)) // $ tainted=44
	sink(arg: [UInt8](sourceString().utf8)[0]) // $ tainted=45

	if let v = sourceInt() as? UInt {
		sink(arg: v) // $ tainted=47
	}

	let v2: UInt8 = numericCast(sourceInt())
	sink(arg: v2) // $ tainted=51

	let v4: UInt = unsafeBitCast(sourceInt(), to: UInt.self)
	sink(arg: v4) // $ tainted=54

	let v5 = UInt(truncatingIfNeeded: sourceInt())
	sink(arg: v5) // $ tainted=57

	let v6 = UInt(bitPattern: sourceInt())
	sink(arg: v6) // $ tainted=60

	let v7 = abs(sourceInt())
	sink(arg: v7) // $ tainted=63

	let v8 = UInt64(0)
	sink(arg: v8)
	sink(arg: v8.advanced(by: 1))
	sink(arg: v8.advanced(by: sourceInt())) // $ tainted=69

	sink(arg: Int(exactly: sourceInt())!) // $ tainted=71
	sink(arg: UInt32(exactly: sourceInt())!) // $ tainted=72
	sink(arg: Int(clamping: sourceInt())) // $ tainted=73
	sink(arg: Int(truncatingIfNeeded: sourceInt())) // $ tainted=74
	sink(arg: Int(sourceString(), radix: 10)!) // $ tainted=75

	sink(arg: Int(littleEndian: sourceInt())) // $ tainted=77
	sink(arg: Int(bigEndian: sourceInt())) // $ tainted=78
	sink(arg: sourceInt().littleEndian) // $ tainted=79
	sink(arg: sourceInt().bigEndian) // $ tainted=80

	let (q1, r1) = 1000.quotientAndRemainder(dividingBy: 2)
	sink(arg: q1)
	sink(arg: r1)

	let (q2, r2) = sourceInt().quotientAndRemainder(dividingBy: 2)
	sink(arg: q2) // $ MISSING: tainted=86
	sink(arg: r2) // $ MISSING: tainted=86

	let (q3, r3) = 1000.quotientAndRemainder(dividingBy: sourceInt())
	sink(arg: q3) // $ MISSING: tainted=90
	sink(arg: r3) // $ MISSING: tainted=90

	let pair1 = 1000.addingReportingOverflow(2)
	sink(arg: pair1.0) // part
	sink(arg: pair1.1) // overflow

	let pair2 = sourceInt().addingReportingOverflow(2)
	sink(arg: pair2.0) // $ MISSING: tainted=98
	sink(arg: pair2.1)

	let pair3 = 1000.addingReportingOverflow(sourceInt())
	sink(arg: pair3.0) // $ MISSING: tainted=102
	sink(arg: pair3.1)

	// ---

	sink(arg: sourceFloat()) // $ tainted=108
	sink(arg: Float(sourceFloat())) // $ tainted=109
	sink(arg: UInt8(sourceFloat())) // $ tainted=110
	sink(arg: String(sourceFloat())) // $ tainted=111
	sink(arg: String(sourceFloat()).utf8) // $ tainted=112
	sink(arg: String(sourceFloat80())) // $ tainted=113
	sink(arg: String(sourceFloat80()).utf8) // $ tainted=114
	sink(arg: String(sourceDouble())) // $ tainted=115
	sink(arg: String(sourceDouble()).utf8) // $ tainted=116

	sink(arg: Float(sourceFloat())) // $ tainted=118
	sink(arg: Float(sign: .plus, exponent: sourceInt(), significand: 0.0)) // $ tainted=119
	sink(arg: Float(sign: .plus, exponent: 0, significand: sourceFloat())) // $ tainted=120
	sink(arg: Float(signOf: sourceFloat(), magnitudeOf: 0.0)) // (good)
	sink(arg: Float(signOf: 0.0, magnitudeOf: sourceFloat())) // $ tainted=122

	sink(arg: sourceFloat().exponent) // $ tainted=124
	sink(arg: sourceFloat().significand) // $ tainted=125
	sink(arg: sourceFloat80().exponent) // $ tainted=126
	sink(arg: sourceFloat80().significand) // $ tainted=127
	sink(arg: sourceDouble().exponent) // $ tainted=128
	sink(arg: sourceDouble().significand) // $ tainted=129
	sink(arg: sourceUInt().byteSwapped) // $ tainted=130
	sink(arg: sourceUInt64().byteSwapped) // $ tainted=131

	// ---

	sink(arg: sourceString()) // $ tainted=135
	sink(arg: String(sourceString())) // $ tainted=136

	let ms1 = MyString("abc")!
	sink(arg: ms1)
	sink(arg: ms1.description)
	sink(arg: ms1.debugDescription)
	sink(arg: ms1.clean)

	let ms2 = MyString(sourceString())!
	sink(arg: ms2) // $ tainted=144
	sink(arg: ms2.description) // $ tainted=144
	sink(arg: ms2.debugDescription) // $ tainted=144
	sink(arg: ms2.clean)

	// ---

	let parent : MyParentClass = sourceString() as! MyChildClass
	sink(arg: parent) // $ tainted=152
	sink(arg: parent as! MyChildClass) // $ tainted=152

	let v3: MyChildClass = unsafeDowncast(parent, to: MyChildClass.self)
	sink(arg: v3) // $ tainted=152
	sink(arg: v3 as! MyParentClass) // $ tainted=152
}

var myCEnumConst : Int = 0
typealias MyCEnumType = UInt32

func testCEnum() {
	sink(arg: MyCEnumType(myCEnumConst))
	sink(arg: MyCEnumType(sourceInt())) // $ tainted=166
}

class TestArrayConversion {
	init() {
		let arr1 = sourceArray("init1")
		let arr2 = [sourceInt()]
		sink(arg: arr1) // $ tainted=init1
		sink(arg: arr2) // $ tainted=172
		sink(arg: arr1[0]) // $ tainted=init1
		sink(arg: arr2[0]) // $ tainted=172

		let arr1b = try Array(arr1)
		let arr2b = try Array(arr2)
		sink(arg: arr1b) // $ tainted=init1
		sink(arg: arr2b) // $ tainted=172
		sink(arg: arr1b[0]) // $ tainted=init1
		sink(arg: arr2b[0]) // $ tainted=172

		let arr1c = ContiguousArray(arr1)
		let arr2c = ContiguousArray(arr2)
		sink(arg: arr1c) // $ tainted=init1
		sink(arg: arr2c) // $ tainted=172
		sink(arg: arr1c[0]) // $ tainted=init1
		sink(arg: arr2c[0]) // $ tainted=172
	}
}

// ---

class MyValue {
	var v : Int

	init(_ v: Int) {
		self.v = v
	}
}

extension Int {
	init(withUInt: UInt) {
		sink(arg: withUInt) // $ tainted=232
		self = Int(withUInt)
		sink(arg:self) // $ tainted=232
	}

	init(withMyValue: MyValue) {
		sink(arg: withMyValue.v) // $ tainted=235
		self = withMyValue.v
		sink(arg:self) // $ MISSING: tainted=235
	}

	init(withMyValue2: MyValue) {
		sink(arg: withMyValue2.v) // $ tainted=238
		let x = withMyValue2.v
		self = x
		sink(arg:self) // $ tainted=238
	}

	static func mkInt(withMyValue: MyValue) -> Int {
		sink(arg: withMyValue.v) // $ tainted=241
		return withMyValue.v
	}
}

func testIntExtensions() {
	sink(arg: Int(withUInt: 0))
	sink(arg: Int(withUInt: sourceUInt())) // $ tainted=232

	sink(arg: Int(withMyValue: MyValue(0)))
	sink(arg: Int(withMyValue: MyValue(sourceInt()))) // $ MISSING: tainted=235

	sink(arg: Int(withMyValue2: MyValue(0)))
	sink(arg: Int(withMyValue2: MyValue(sourceInt()))) // $ tainted=238

	sink(arg: Int.mkInt(withMyValue: MyValue(0)))
	sink(arg: Int.mkInt(withMyValue: MyValue(sourceInt()))) // $ tainted=241
}
