
func sourceInt(_ label: String) -> Int { 0 }
func sourceUInt(_ label: String) -> UInt { 0 }
func sourceUInt64(_ label: String) -> UInt64 { 0 }
func sourceFloat(_ label: String) -> Float { 0.0 }
func sourceFloat80(_ label: String) -> Float80 { 0.0 }
func sourceDouble(_ label: String) -> Double { 0.0 }
func sourceString(_ label: String) -> String { "" }
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
	sink(arg: sourceInt("conv1-1")) // $ tainted=conv1-1
	sink(arg: Int(sourceInt("conv1-2"))) // $ tainted=conv1-2
	sink(arg: Int8(sourceInt("conv1-3"))) // $ tainted=conv1-3
	sink(arg: Int16(sourceInt("conv1-4"))) // $ tainted=conv1-4
	sink(arg: Int32(sourceInt("conv1-5"))) // $ tainted=conv1-5
	sink(arg: Int64(sourceInt("conv1-6"))) // $ tainted=conv1-6
	//sink(arg: Int128(sourceInt("conv1-7"))) --- doesn't build in test (yet)
	sink(arg: UInt(sourceInt("conv1-8"))) // $ tainted=conv1-8
	sink(arg: UInt8(sourceInt("conv1-9"))) // $ tainted=conv1-9
	sink(arg: UInt16(sourceInt("conv1-10"))) // $ tainted=conv1-10
	sink(arg: UInt32(sourceInt("conv1-11"))) // $ tainted=conv1-11
	sink(arg: UInt64(sourceInt("conv1-12"))) // $ tainted=conv1-12
	//sink(arg: UInt128(sourceInt("conv1-13"))) --- doesn't build in test (yet)
	sink(arg: Float(sourceInt("conv1-14"))) // $ tainted=conv1-14
	sink(arg: Double(sourceInt("conv1-15"))) // $ tainted=conv1-15
	sink(arg: String(sourceInt("conv1-16"))) // $ tainted=conv1-16
	sink(arg: String(sourceInt("conv1-17")).utf8) // $ tainted=conv1-17

	let arr = [1, 2, sourceInt("conv2-1")]
	sink(arg: arr) // $ tainted=conv2-1
	sink(arg: arr[0]) // $ tainted=conv2-1
	sink(arg: [MyInt](arr)) // $ tainted=conv2-1
	sink(arg: [MyInt](arr)[0]) // $ tainted=conv2-1
	sink(arg: [UInt8](sourceString("conv2-2").utf8)) // $ tainted=conv2-2
	sink(arg: [UInt8](sourceString("conv2-3").utf8)[0]) // $ tainted=conv2-3

	if let v = sourceInt("conv3-1") as? UInt {
		sink(arg: v) // $ tainted=conv3-1
	}

	let v2: UInt8 = numericCast(sourceInt("conv3-2"))
	sink(arg: v2) // $ tainted=conv3-2

	let v4: UInt = unsafeBitCast(sourceInt("conv3-3"), to: UInt.self)
	sink(arg: v4) // $ tainted=conv3-3

	let v5 = UInt(truncatingIfNeeded: sourceInt("conv3-4"))
	sink(arg: v5) // $ tainted=conv3-4

	let v6 = UInt(bitPattern: sourceInt("conv3-5"))
	sink(arg: v6) // $ tainted=conv3-5

	let v7 = abs(sourceInt("conv3-6"))
	sink(arg: v7) // $ tainted=conv3-6

	let v8 = UInt64(0)
	sink(arg: v8)
	sink(arg: v8.advanced(by: 1))
	sink(arg: v8.advanced(by: sourceInt("conv3-7"))) // $ tainted=conv3-7
	sink(arg: v8.distance(to: 1))
	sink(arg: v8.distance(to: sourceUInt64("conv3-8"))) // $ tainted=conv3-8

	sink(arg: Int(exactly: sourceInt("conv4-1"))!) // $ tainted=conv4-1
	sink(arg: UInt32(exactly: sourceInt("conv4-2"))!) // $ tainted=conv4-2
	sink(arg: Int(clamping: sourceInt("conv4-3"))) // $ tainted=conv4-3
	sink(arg: UInt32(clamping: sourceInt("conv4-4"))) // $ tainted=conv4-4
	sink(arg: Int(truncatingIfNeeded: sourceInt("conv4-5"))) // $ tainted=conv4-5
	sink(arg: UInt32(truncatingIfNeeded: sourceInt("conv4-6"))) // $ tainted=conv4-6
	sink(arg: Int(sourceString("conv4-7"), radix: 10)!) // $ tainted=conv4-7
	sink(arg: UInt32(sourceString("conv4-8"), radix: 10)!) // $ tainted=conv4-8

	sink(arg: Int(littleEndian: sourceInt("conv5-1"))) // $ tainted=conv5-1
	sink(arg: UInt64(littleEndian: sourceUInt64("conv5-2"))) // $ tainted=conv5-2
	sink(arg: Int(bigEndian: sourceInt("conv5-3"))) // $ tainted=conv5-3
	sink(arg: UInt64(bigEndian: sourceUInt64("conv5-4"))) // $ tainted=conv5-4
	sink(arg: sourceInt("conv5-5").littleEndian) // $ tainted=conv5-5
	sink(arg: sourceUInt64("conv5-6").littleEndian) // $ tainted=conv5-6
	sink(arg: sourceInt("conv5-7").bigEndian) // $ tainted=conv5-7
	sink(arg: sourceUInt64("conv5-8").bigEndian) // $ tainted=conv5-8

	let (q1, r1) = 1000.quotientAndRemainder(dividingBy: 2)
	sink(arg: q1)
	sink(arg: r1)

	let (q2, r2) = sourceInt("conv6-1").quotientAndRemainder(dividingBy: 2)
	sink(arg: q2) // $ MISSING: tainted=conv6-1
	sink(arg: r2) // $ MISSING: tainted=conv6-1

	let (q3, r3) = 1000.quotientAndRemainder(dividingBy: sourceInt("conv6-2"))
	sink(arg: q3) // $ MISSING: tainted=conv6-2
	sink(arg: r3) // $ MISSING: tainted=conv6-2

	let (q4, r4) = UInt64(1000).quotientAndRemainder(dividingBy: sourceUInt64("conv6-3"))
	sink(arg: q4) // $ MISSING: tainted=conv6-3
	sink(arg: r4) // $ MISSING: tainted=conv6-3

	let pair1 = 1000.addingReportingOverflow(2)
	sink(arg: pair1.0) // part
	sink(arg: pair1.1) // overflow

	let pair2 = sourceInt("conv6-4").addingReportingOverflow(2)
	sink(arg: pair2.0) // $ MISSING: tainted=conv6-4
	sink(arg: pair2.1)

	let pair3 = 1000.addingReportingOverflow(sourceInt("conv6-5"))
	sink(arg: pair3.0) // $ MISSING: tainted=conv6-5
	sink(arg: pair3.1)

	let pair4 = UInt64(1000).addingReportingOverflow(sourceUInt64("conv6-6"))
	sink(arg: pair4.0) // $ MISSING: tainted=conv6-6
	sink(arg: pair4.1)

	// ---

	sink(arg: sourceFloat("conv7-1")) // $ tainted=conv7-1
	sink(arg: Float(sourceFloat("conv7-2"))) // $ tainted=conv7-2
	sink(arg: UInt8(sourceFloat("conv7-3"))) // $ tainted=conv7-3
	sink(arg: String(sourceFloat("conv7-4"))) // $ tainted=conv7-4
	sink(arg: String(sourceFloat("conv7-5")).utf8) // $ tainted=conv7-5
	sink(arg: String(sourceFloat80("conv7-6"))) // $ tainted=conv7-6
	sink(arg: String(sourceFloat80("conv7-7")).utf8) // $ tainted=conv7-7
	sink(arg: String(sourceDouble("conv7-8"))) // $ tainted=conv7-8
	sink(arg: String(sourceDouble("conv7-9")).utf8) // $ tainted=conv7-9

	sink(arg: Float(sourceFloat("conv8-1"))) // $ tainted=conv8-1
	sink(arg: Float(sign: .plus, exponent: sourceInt("conv8-2"), significand: 0.0)) // $ tainted=conv8-2
	sink(arg: Float(sign: .plus, exponent: 0, significand: sourceFloat("conv8-3"))) // $ tainted=conv8-3
	sink(arg: Float(signOf: sourceFloat("conv8-4"), magnitudeOf: 0.0)) // (good)
	sink(arg: Float(signOf: 0.0, magnitudeOf: sourceFloat("conv8-5"))) // $ tainted=conv8-5

	sink(arg: sourceFloat("conv9-1").exponent) // $ tainted=conv9-1
	sink(arg: sourceFloat("conv9-2").significand) // $ tainted=conv9-2
	sink(arg: sourceFloat80("conv9-3").exponent) // $ tainted=conv9-3
	sink(arg: sourceFloat80("conv9-4").significand) // $ tainted=conv9-4
	sink(arg: sourceDouble("conv9-5").exponent) // $ tainted=conv9-5
	sink(arg: sourceDouble("conv9-6").significand) // $ tainted=conv9-6
	sink(arg: sourceUInt("conv9-7").byteSwapped) // $ tainted=conv9-7
	sink(arg: sourceUInt64("conv9-8").byteSwapped) // $ tainted=conv9-8
	sink(arg: sourceInt("conv9-9").magnitude) // $ tainted=conv9-9
	sink(arg: sourceUInt64("conv9-10").magnitude) // $ tainted=conv9-10

	// ---

	sink(arg: sourceString("conv10-1")) // $ tainted=conv10-1
	sink(arg: String(sourceString("conv10-2"))) // $ tainted=conv10-2

	let ms1 = MyString("abc")!
	sink(arg: ms1)
	sink(arg: ms1.description)
	sink(arg: ms1.debugDescription)
	sink(arg: ms1.clean)

	let ms2 = MyString(sourceString("conv11-1"))!
	sink(arg: ms2) // $ tainted=conv11-1
	sink(arg: ms2.description) // $ tainted=conv11-1
	sink(arg: ms2.debugDescription) // $ tainted=conv11-1
	sink(arg: ms2.clean)

	// ---

	let parent : MyParentClass = sourceString("conv12-1") as! MyChildClass
	sink(arg: parent) // $ tainted=conv12-1
	sink(arg: parent as! MyChildClass) // $ tainted=conv12-1

	let v3: MyChildClass = unsafeDowncast(parent, to: MyChildClass.self)
	sink(arg: v3) // $ tainted=conv12-1
	sink(arg: v3 as! MyParentClass) // $ tainted=conv12-1
}

var myCEnumConst : Int = 0
typealias MyCEnumType = UInt32

func testCEnum() {
	sink(arg: MyCEnumType(myCEnumConst))
	sink(arg: MyCEnumType(sourceInt("cenum"))) // $ tainted=cenum
}

class TestArrayConversion {
	init() {
		let arr1 = sourceArray("init1")
		let arr2 = [sourceInt("init2")]
		sink(arg: arr1) // $ tainted=init1
		sink(arg: arr2) // $ tainted=init2
		sink(arg: arr1[0]) // $ tainted=init1
		sink(arg: arr2[0]) // $ tainted=init2

		let arr1b = try Array(arr1)
		let arr2b = try Array(arr2)
		sink(arg: arr1b) // $ tainted=init1
		sink(arg: arr2b) // $ tainted=init2
		sink(arg: arr1b[0]) // $ tainted=init1
		sink(arg: arr2b[0]) // $ tainted=init2

		let arr1c = ContiguousArray(arr1)
		let arr2c = ContiguousArray(arr2)
		sink(arg: arr1c) // $ tainted=init1
		sink(arg: arr2c) // $ tainted=init2
		sink(arg: arr1c[0]) // $ tainted=init1
		sink(arg: arr2c[0]) // $ tainted=init2
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
		sink(arg: withUInt) // $ tainted=ext1
		self = Int(withUInt)
		sink(arg:self) // $ tainted=ext1
	}

	init(withMyValue: MyValue) {
		sink(arg: withMyValue.v) // $ tainted=ext2
		self = withMyValue.v
		sink(arg:self) // $ MISSING: tainted=ext2
	}

	init(withMyValue2: MyValue) {
		sink(arg: withMyValue2.v) // $ tainted=ext3
		let x = withMyValue2.v
		self = x
		sink(arg:self) // $ tainted=ext3
	}

	static func mkInt(withMyValue: MyValue) -> Int {
		sink(arg: withMyValue.v) // $ tainted=ext4
		return withMyValue.v
	}
}

func testIntExtensions() {
	sink(arg: Int(withUInt: 0))
	sink(arg: Int(withUInt: sourceUInt("ext1"))) // $ tainted=ext1

	sink(arg: Int(withMyValue: MyValue(0)))
	sink(arg: Int(withMyValue: MyValue(sourceInt("ext2")))) // $ MISSING: tainted=ext2

	sink(arg: Int(withMyValue2: MyValue(0)))
	sink(arg: Int(withMyValue2: MyValue(sourceInt("ext3")))) // $ tainted=ext3

	sink(arg: Int.mkInt(withMyValue: MyValue(0)))
	sink(arg: Int.mkInt(withMyValue: MyValue(sourceInt("ext4")))) // $ tainted=ext4
}
