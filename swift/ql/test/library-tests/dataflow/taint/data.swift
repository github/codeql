// --- stubs ---
struct URL {}

class NSData {}

protocol SortComparator {
	associatedtype Compared
}
struct Data
{
	struct Base64EncodingOptions : OptionSet { let rawValue: Int }
	struct Base64DecodingOptions : OptionSet { let rawValue: Int }
	enum Deallocator { case none }
	struct ReadingOptions : OptionSet { let rawValue: Int }
	typealias Index = Int
    init<S>(_ elements: S) {}
	init(base64Encoded: Data, options: Data.Base64DecodingOptions) {}
	init<SourceType>(buffer: UnsafeBufferPointer<SourceType>) {}
	init<SourceType>(buffer: UnsafeMutablePointer<SourceType>) {}
	init(bytes: UnsafeRawPointer, count: Int) {}
	init(bytesNoCopy: UnsafeRawPointer, count: Int, deallocator: Data.Deallocator) {}
	init(contentsOf: URL, options: ReadingOptions) {}
	init(referencing: NSData) {}
	func append(_: Data) {}
	func append(_: UInt8) {}
	func append<SourceType>(_: UnsafeBufferPointer<SourceType>) {}
	func append(_: UnsafePointer<UInt8>, count: Int) {}
	func append(contentsOf: [UInt8]) {}
	func append<S>(contentsOf: S) {}
	func base64EncodedData(options: Data.Base64EncodingOptions) -> Data { return Data("") }
	func base64EncodedString(options: Data.Base64EncodingOptions) -> String { return "" }
	func compactMap<ElementOfResult>(_: (UInt8) -> ElementOfResult) -> [ElementOfResult] { return [] }
	func copyBytes(to: UnsafeMutableRawBufferPointer) {}
	func copyBytes(to: UnsafeMutablePointer<UInt8>, count: Int) {}
	func copyBytes(to: UnsafeMutablePointer<UInt8>, from: Range<Data.Index>) {}
	func flatMap<SegmentOfResult>(_: (UInt8) -> SegmentOfResult) -> [SegmentOfResult.Element] where SegmentOfResult : Sequence { return [] }
	func flatMap<ElementOfResult>(_: (UInt8) -> ElementOfResult?) -> [ElementOfResult] { return [] }
	func insert(_: UInt8, at: Int) {}
	func insert<C>(contentsOf: C, at: Int) where C : Collection, UInt8 == C.Element {}
	func map<T>(_: (UInt8) -> T) -> [T] { return [] }
	func reduce<Result>(into initialResult: Result, _: (inout Result, UInt8) -> ()) -> Result { return initialResult }
	func replace<C, Replacement>(_: C, with: Replacement, maxReplacements: Int) where C : Collection, Replacement : Collection, UInt8 == C.Element, C.Element == Replacement.Element {}
	func replaceSubrange(_: Range<Data.Index>, with: Data) {}
	func replaceSubrange<ByteCollection>(_: Range<Data.Index>, with: ByteCollection) where ByteCollection : Collection, ByteCollection.Element == UInt8 {}
	func replaceSubrange<SourceType>(_: Range<Data.Index>, with: UnsafeBufferPointer<SourceType>) {}
	func replaceSubrange(_: Range<Data.Index>, with: UnsafeRawPointer, count: Int) {}
	func replaceSubrange<C, R>(_: R, with: C) where C : Collection, R : RangeExpression, UInt8 == C.Element, Int == R.Bound {}
	func replacing<C, Replacement>(_: C, with: Replacement, maxReplacements: Int = .max) -> Data where C : Collection, Replacement : Collection, UInt8 == C.Element, C.Element == Replacement.Element { return Data("") }
	func replacing<C, Replacement>(_: C, with: Replacement, subrange: Range<Int>, maxReplacements: Int = .max) -> Data where C : Collection, Replacement : Collection, UInt8 == C.Element, C.Element == Replacement.Element { return Data("") }
	func shuffled() -> [UInt8] { return [] }
	func shuffled<T>(using: inout T) -> [UInt8] { return [] }
	func sorted<Comparator>(using: Comparator) -> [UInt8] where Comparator : SortComparator, UInt8 == Comparator.Compared { return [] }
	func trimmingPrefix<Prefix>(_ prefix: Prefix) -> Data where Prefix : Sequence, UInt8 == Prefix.Element { return Data("") }
	func trimmingPrefix(while: (UInt8) -> Bool) -> Data { return Data("") }
}

// --- tests ---

class UInt8SortCompartor : SortComparator {
	typealias Compared = UInt8
}

func source() -> Any { return "" }
func sink(arg: Any) {}
func rng() -> RandomNumberGenerator? { return nil }
func cmp() -> UInt8SortCompartor? { return nil }

func taintThroughData() {
	// ";Data;true;init(_:);;;Argument[0];ReturnValue;taint",
	let dataClean = Data("123456".utf8)
	let dataTainted = Data((source() as! String).utf8)
	let dataTainted2 = Data(dataTainted)

	sink(arg: dataClean)
	sink(arg: dataTainted) // $ MISSING: tainted=71
	sink(arg: dataTainted2) // $ MISSING: tainted=71

	// ";Data;true;init(base64Encoded:options:);;;Argument[0];ReturnValue;taint",
	let dataTainted3 = Data(base64Encoded: source() as! Data, options: [])
	sink(arg: dataTainted3) // $ tainted=79

	// ";Data;true;init(buffer:);;;Argument[0];ReturnValue;taint",
	let dataTainted4 = Data(buffer: source() as! UnsafeBufferPointer<UInt8>)
	sink(arg: dataTainted4)  // $ tainted=83
	let dataTainted5 = Data(buffer: source() as! UnsafeMutablePointer<UInt8>)
	sink(arg: dataTainted5)  // $ tainted=85

	// ";Data;true;init(bytes:count:);;;Argument[0];ReturnValue;taint",
	let dataTainted6 = Data(bytes: source() as! UnsafeRawPointer, count: 0)
	sink(arg: dataTainted6)  // $ tainted=89

	// ";Data;true;init(bytesNoCopy:count:deallocator:);;;Argument[0];ReturnValue;taint",
	let dataTainted7 = Data(bytesNoCopy: source() as! UnsafeRawPointer, count: 0, deallocator: Data.Deallocator.none)
	sink(arg: dataTainted7)  // $ tainted=93

	// ";Data;true;init(contentsOf:options:);;;Argument[0];ReturnValue;taint",
	let dataTainted8 = Data(contentsOf: source() as! URL, options: [])
	sink(arg: dataTainted8)  // $ tainted=97

	// ";Data;true;init(referencing:);;;Argument[0];ReturnValue;taint",
	let dataTainted9 = Data(referencing: source() as! NSData)
	sink(arg: dataTainted9)  // $ tainted=101

	// ";Data;true;append(_:);;;Argument[0];Argument[-1];taint",
	let dataTainted10 = Data("")
	dataTainted10.append(source() as! Data)
	sink(arg: dataTainted10) // $ tainted=106

	let dataTainted11 = Data("")
	dataTainted11.append(source() as! UInt8)
	sink(arg: dataTainted11) // $ tainted=110

	let dataTainted12 = Data("")
	dataTainted12.append(source() as! UnsafeBufferPointer<UInt8>)
	sink(arg: dataTainted12) // $ tainted=114

	// ";Data;true;append(_:count:);;;Argument[0];Argument[-1];taint",
	let dataTainted13 = Data("")
	dataTainted13.append(source() as! UnsafePointer<UInt8>, count: 0)
	sink(arg: dataTainted13) // $ tainted=119

	// ";Data;true;append(contentsOf:);;;Argument[0];Argument[-1];taint",
	let dataTainted14 = Data("")
	dataTainted14.append(contentsOf: source() as! [UInt8])
	sink(arg: dataTainted14) // $ tainted=124

	// ";Data;true;base64EncodedData(options:);;;Argument[-1];ReturnValue;taint",
	let dataTainted15 = source() as! Data
	sink(arg: dataTainted15.base64EncodedData(options: [])) // $ tainted=128

	// ";Data;true;base64EncodedString(options:);;;Argument[-1];ReturnValue;taint",
	let dataTainted16 = source() as! Data
	sink(arg: dataTainted16.base64EncodedString(options: [])) // $ tainted=132

	// ";Data;true;compactMap(_:);;;Argument[-1];ReturnValue;taint",
	let dataTainted17 = source() as! Data
	let compactMapped: [Int] = dataTainted17.compactMap { str in Int(str) }
	sink(arg: compactMapped) // $ tainted=136

	// ";Data;true;copyBytes(to:);;;Argument[-1];Argument[0];taint",
	let dataTainted18 = source() as! Data
	let pointerTainted18 = UnsafeMutableRawBufferPointer.allocate(byteCount: 0, alignment: 0)
	dataTainted18.copyBytes(to: pointerTainted18)
	sink(arg: pointerTainted18) // $ tainted=141

	// ";Data;true;copyBytes(to:count:);;;Argument[-1];Argument[0];taint",
	let dataTainted19 = source() as! Data
	let pointerTainted19 = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
	dataTainted19.copyBytes(to: pointerTainted19, count: 0)
	sink(arg: pointerTainted19) // $ MISSING: tainted=147

	// ";Data;true;copyBytes(to:from:);;;Argument[-1];Argument[0];taint",
	let dataTainted20 = source() as! Data
	let pointerTainted20 = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
	dataTainted20.copyBytes(to: pointerTainted20, from: 0..<1)
	sink(arg: pointerTainted20) // $ MISSING: tainted=153

	// ";Data;true;flatMap(_:);;;Argument[-1];ReturnValue;taint",
	let dataTainted21 = source() as! Data
	let flatMapped = dataTainted21.flatMap { Array(repeating: $0, count: 0) }
	sink(arg: flatMapped) // $ tainted=159

	let dataTainted22 = source() as! Data
	let flatMapped2 = dataTainted22.flatMap { str in Int(str) }
	sink(arg: flatMapped2) // $ tainted=163

	// ";Data;true;insert(_:at:);;;Argument[0];Argument[-1];taint",
	let dataTainted23 = Data("")
	dataTainted23.insert(source() as! UInt8, at: 0)
	sink(arg: dataTainted23) // $ tainted=169

	// ";Data;true;insert(contentsOf:at:);;;Argument[0];Argument[-1];taint",
	let dataTainted24 = Data("")
	dataTainted24.insert(contentsOf: source() as! [UInt8], at: 0)
	sink(arg: dataTainted24) // $ tainted=174

	// ";Data;true;map(_:);;;Argument[-1];ReturnValue;taint",
	let dataTainted25 = source() as! Data
	let mapped = dataTainted25.map { $0 }
	sink(arg: mapped) // $ tainted=178

	// ";Data;true;reduce(into:_:);;;Argument[-1];ReturnValue;taint",
	let dataTainted26 = source() as! Data
	let reduced = dataTainted26.reduce(into: [:]) { c, i in c[i, default: 0] += 1 }
	sink(arg: reduced) // $ tainted=183

	// ";Data;true;replace(_:with:maxReplacements:);;;Argument[1];Argument[-1];taint",
	let dataTainted27 = Data("")
	dataTainted27.replace([0], with: source() as! [UInt8], maxReplacements: .max)
	sink(arg: dataTainted27) // $ tainted=189

	// ";Data;true;replaceSubrange(_:with:);;;Argument[1];Argument[-1];taint",
	let dataTainted28 = Data("")
	dataTainted28.replaceSubrange(1..<3, with: source() as! Data)
	sink(arg: dataTainted28) // $ tainted=194

	let dataTainted29 = Data("")
	dataTainted29.replaceSubrange(1..<3, with: source() as! [UInt8])
	sink(arg: dataTainted29) // $ tainted=198

	let dataTainted30 = Data("")
	dataTainted30.replaceSubrange(1..<3, with: source() as! UnsafeBufferPointer<UInt8>)
	sink(arg: dataTainted30) // $ tainted=202

	// ";Data;true;replaceSubrange(_:with:count:);;;Argument[1];Argument[-1];taint",
	let dataTainted31 = Data("")
	dataTainted31.replaceSubrange(1..<3, with: source() as! UnsafeRawPointer, count: 0)
	sink(arg: dataTainted31) // $ tainted=207

	// ";Data;true;replacing(_:with:maxReplacements:);;;Argument[1];Argument[-1];taint",
	let dataTainted32 = Data("")
	dataTainted32.replacing([0], with: source() as! [UInt8], maxReplacements: 0)
	sink(arg: dataTainted32) // $ tainted=212

	// ";Data;true;replacing(_:with:subrange:maxReplacements:);;;Argument[1];Argument[-1];taint",
	let dataTainted33 = Data("")
	dataTainted33.replacing([0], with: source() as! [UInt8], subrange: 1..<3, maxReplacements: 0)
	sink(arg: dataTainted33) // $ tainted=217

	// ";Data;true;shuffled();;;Argument[-1];ReturnValue;taint",
	let dataTainted34 = source() as! Data
	sink(arg: dataTainted34.shuffled()) // $ tainted=221
	
	// ";Data;true;shuffled(using:);;;Argument[-1];ReturnValue;taint",
	let dataTainted35 = source() as! Data
	var rng = rng()!
	sink(arg: dataTainted35.shuffled(using: &rng)) // $ tainted=225

	// ";Data;true;sorted(using:);;;Argument[-1];ReturnValue;taint",
	let dataTainted36 = source() as! Data
	sink(arg: dataTainted36.sorted(using: cmp()!)) // $ tainted=230

	// ";Data;true;trimmingPrefix(_:);;;Argument[-1];ReturnValue;taint",
	let dataTainted37 = source() as! Data
	sink(arg: dataTainted37.trimmingPrefix([0])) // $ tainted=234

	// ";Data;true;trimmingPrefix(while:);;;Argument[-1];ReturnValue;taint"
	let dataTainted38 = source() as! Data
	sink(arg: dataTainted38.trimmingPrefix { _ in false }) // $ tainted=238

}
