
// --- stubs ---

typealias unichar = UInt16

struct Locale {
}




















enum CInterop {
  typealias Char = CChar
  typealias PlatformChar = CInterop.Char
}

struct CharacterSet {
  static var whitespaces: CharacterSet { get { return CharacterSet() } }
}

class NSObject {
}

class NSString : NSObject {
  struct CompareOptions : OptionSet {
    init(rawValue: UInt) { self.rawValue = rawValue }

    var rawValue: UInt
  }
}

extension String : CVarArg {
  typealias CompareOptions = NSString.CompareOptions

  public var _cVarArgEncoding: [Int] { get { return [] } }
  static var availableStringEncodings: [String.Encoding] { get { [] } }
  static var defaultCStringEncoding: String.Encoding { get { String.Encoding.utf8 } }

	struct Encoding {
		static let utf8 = Encoding()
	}

	init?(data: Data, encoding: Encoding) { self.init() }



  init(format: String, _ arguments: CVarArg...) { self.init() }
  init(format: String, arguments: [CVarArg]) { self.init() }
  init(format: String, locale: Locale?, _ args: CVarArg...) { self.init() }
  init(format: String, locale: Locale?, arguments: [CVarArg]) { self.init() }

  static func localizedStringWithFormat(_ format: String, _ arguments: CVarArg...) -> String { return "" }

  init?<S>(bytes: S, encoding: String.Encoding) where S : Sequence, S.Element == UInt8 { self.init() }

  init(cString nullTerminatedUTF8: UnsafePointer<CChar>) { self.init() }
  init(cString nullTerminatedUTF8: UnsafePointer<UInt8>) { self.init() }
  init?(bytesNoCopy bytes: UnsafeMutableRawPointer, length: Int, encoding: String.Encoding, freeWhenDone flag: Bool) { self.init() }
  init?(utf8String bytes: UnsafePointer<CChar>) { self.init() }
  init(utf16CodeUnits: UnsafePointer<unichar>, count: Int) { self.init() }
  init(utf16CodeUnitsNoCopy: UnsafePointer<unichar>, count: Int, freeWhenDone flag: Bool) { self.init() }

  init(platformString: UnsafePointer<CInterop.PlatformChar>) { self.init() }

  func withPlatformString<Result>(_ body: (UnsafePointer<CInterop.PlatformChar>) throws -> Result) rethrows -> Result { return 0 as! Result }
  mutating func withMutableCharacters<R>(_ body: (inout String) -> R) -> R { return 0 as! R }


  mutating func replaceSubrange<C>(_ subrange: Range<String.Index>, with newElements: C)
    where C : Collection, C.Element == Character {}
}

extension StringProtocol {
  var capitalized: String { get { "" } }
  var localizedCapitalized: String { get { "" } }
  var localizedLowercase: String { get { "" } }
  var localizedUppercase: String { get { "" } }
  var removingPercentEncoding: String? { get { "" } }
  var decomposedStringWithCanonicalMapping: String { get { "" } }
  var decomposedStringWithCompatibilityMapping: String { get { "" } }
  var precomposedStringWithCanonicalMapping: String { get { "" } }
  var precomposedStringWithCompatibilityMapping: String { get { "" } }

  func lowercased(with locale: Locale?) -> String { return "" }
  func uppercased(with locale: Locale?) -> String { return "" }
  func capitalized(with locale: Locale?) -> String { return "" }
  func substring(from index: Self.Index) -> String { return "" }
  func trimmingCharacters(in set: CharacterSet) -> String { return "" }
  func appending<T>(_ aString: T) -> String where T : StringProtocol { return "" }
  func appendingFormat<T>(_ format: T, _ arguments: CVarArg...) -> String where T : StringProtocol { return "" }
  func padding<T>(toLength newLength: Int, withPad padString: T, startingAt padIndex: Int) -> String where T: StringProtocol { return "" }
  func components(separatedBy separator: CharacterSet) -> [String] { return [] }
  func folding(options: String.CompareOptions = [], locale: Locale?) -> String { return "" }
  func propertyListFromStringsFileFormat() -> [String : String] { return [:] }
  func cString(using encoding: String.Encoding) -> [CChar]? { return nil }
  func enumerateLines(invoking body: @escaping (String, inout Bool) -> Void) {}
  func replacingOccurrences<Target, Replacement>(of target: Target, with replacement: Replacement, options: String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil) -> String
    where Target : StringProtocol, Replacement : StringProtocol { return "" }
}

class Data
{
    init<S>(_ elements: S) {}
}

extension Data : Collection {
  typealias Index = Int

  var startIndex: Data.Index { get { return 0 } }
  var endIndex: Data.Index { get { return 0 } }
  subscript(index: Data.Index) -> UInt8 { get { return 0 } }
  func index(after i: Data.Index) -> Data.Index { return 0 }
}

// --- tests ---

func source() -> Int { return 0; }
func sink(arg: Any) {}

func taintThroughInterpolatedStrings() {
  var x = source()

  sink(arg: "\(x)") // $ tainted=137

  sink(arg: "\(x) \(x)") // $ tainted=137

  sink(arg: "\(x) \(0) \(x)") // $ tainted=137

  let y = 42

  sink(arg: "\(y)") // clean

  sink(arg: "\(x) hello \(y)") // $ tainted=137

  sink(arg: "\(y) world \(x)") // $ tainted=137

  x = 0
  sink(arg: "\(x)") // clean
}

func source2() -> String { return ""; }

func taintThroughStringConcatenation() {
  let clean = "abcdef"
  let tainted = source2()

  sink(arg: clean)
  sink(arg: tainted) // $ tainted=161

  sink(arg: clean + clean)
  sink(arg: clean + tainted) // $ tainted=161
  sink(arg: tainted + clean) // $ tainted=161
  sink(arg: tainted + tainted) // $ tainted=161

  sink(arg: ">" + clean + "<")
  sink(arg: ">" + tainted + "<") // $ tainted=161

  sink(arg: clean.appending(clean))
  sink(arg: clean.appending(tainted)) // $ tainted=161
  sink(arg: tainted.appending(clean)) // $ tainted=161
  sink(arg: tainted.appending(tainted)) // $ tainted=161

  var str = "abc"
  sink(arg: str)
  str += "def"
  sink(arg: str)
  str += source2()
  sink(arg: str) // $ tainted=183

  var str2 = "abc"
  sink(arg: str2)
  str2.append("def")
  sink(arg: str2)
  str2.append(source2())
  sink(arg: str2) // $ tainted=190

  var str3 = "abc"
  sink(arg: str3)
  str3.append(contentsOf: "def")
  sink(arg: str3)
  str3.append(contentsOf: source2())
  sink(arg: str3) // $ tainted=197

  var str4 = "abc"
  sink(arg: str4)
  str4.write("def")
  sink(arg: str4)
  str4.write(source2())
  sink(arg: str4) // $ tainted=204

  var str5 = "abc"
  sink(arg: str5)
  str5.insert(contentsOf: "abc", at: str5.startIndex)
  sink(arg: str5)
  str5.insert(contentsOf: source2(), at: str5.startIndex)
  sink(arg: str5) // $ tainted=211
}

func taintThroughSimpleStringOperations() {
  let clean = ""
  let tainted = source2()
  let taintedInt = source()

  sink(arg: String(clean))
  sink(arg: String(tainted)) // $ tainted=217
  sink(arg: String(taintedInt)) // $ tainted=218

  sink(arg: String(format: tainted, 1, 2, 3)) // $ tainted=217
  sink(arg: String(format: tainted, arguments: [])) // $ tainted=217
  sink(arg: String(format: tainted, locale: nil, 1, 2, 3)) // $ tainted=217
  sink(arg: String(format: tainted, locale: nil, arguments: [])) // $ tainted=217
  sink(arg: String.localizedStringWithFormat(tainted, 1, 2, 3)) // $ tainted=217
  sink(arg: String.localizedStringWithFormat("%i %s %i", 1, tainted, 3)) // $ tainted=217
  sink(arg: String(format: "%s", tainted)) // $ tainted=217
  sink(arg: String(format: "%i %i %i", 1, 2, taintedInt)) // $ tainted=218

  sink(arg: String(repeating: clean, count: 2))
  sink(arg: String(repeating: tainted, count: 2)) // $ tainted=217

  sink(arg: tainted.dropFirst(10)) // $ tainted=217
  sink(arg: tainted.dropLast(10)) // $ tainted=217
  sink(arg: tainted.substring(from: tainted.startIndex)) // $ tainted=217
  sink(arg: tainted.lowercased()) // $ tainted=217
  sink(arg: tainted.uppercased()) // $ tainted=217
  sink(arg: tainted.lowercased(with: nil)) // $ tainted=217
  sink(arg: tainted.uppercased(with: nil)) // $ tainted=217
  sink(arg: tainted.capitalized(with: nil)) // $ tainted=217
  sink(arg: tainted.reversed()) // $ tainted=217

  sink(arg: tainted.split(separator: ",")) // $ tainted=217
  sink(arg: tainted.split(whereSeparator: {
    c in return (c == ",")
  })) // $ tainted=217
  sink(arg: tainted.trimmingCharacters(in: CharacterSet.whitespaces)) // $ tainted=217
  sink(arg: tainted.padding(toLength: 20, withPad: " ", startingAt: 0)) // $ tainted=217
  sink(arg: tainted.components(separatedBy: CharacterSet.whitespaces)) // $ tainted=217
  sink(arg: tainted.components(separatedBy: CharacterSet.whitespaces)[0]) // $ tainted=217
  sink(arg: tainted.folding(locale: nil)) // $ tainted=217
  sink(arg: tainted.propertyListFromStringsFileFormat()) // $ tainted=217
  sink(arg: tainted.propertyListFromStringsFileFormat()["key"]!) // $ tainted=217

  sink(arg: clean.enumerateLines(invoking: {
    line, stop in
    sink(arg: line)
    sink(arg: stop)
  }))
  sink(arg: tainted.enumerateLines(invoking: {
    line, stop in
    sink(arg: line) // $ MISSING: tainted=217
    sink(arg: stop)
  }))

  sink(arg: [clean, clean].joined())
  sink(arg: [tainted, clean].joined()) // $ tainted=217
  sink(arg: [clean, tainted].joined()) // $ tainted=217
  sink(arg: [tainted, tainted].joined()) // $ tainted=217

  sink(arg: clean.description)
  sink(arg: tainted.description) // $ tainted=217
  sink(arg: clean.debugDescription)
  sink(arg: tainted.debugDescription) // $ tainted=217
  sink(arg: clean.utf8)
  sink(arg: tainted.utf8) // $ tainted=217
  sink(arg: clean.utf16)
  sink(arg: tainted.utf16) // $ tainted=217
  sink(arg: clean.unicodeScalars)
  sink(arg: tainted.unicodeScalars) // $ tainted=217
  sink(arg: clean.utf8CString)
  sink(arg: tainted.utf8CString) // $ tainted=217
  sink(arg: clean.lazy)
  sink(arg: tainted.lazy) // $ tainted=217
  sink(arg: clean.capitalized)
  sink(arg: tainted.capitalized) // $ tainted=217
  sink(arg: clean.localizedCapitalized)
  sink(arg: tainted.localizedCapitalized) // $ tainted=217
  sink(arg: clean.localizedLowercase)
  sink(arg: tainted.localizedLowercase) // $ tainted=217
  sink(arg: clean.localizedUppercase)
  sink(arg: tainted.localizedUppercase) // $ tainted=217
  sink(arg: clean.decomposedStringWithCanonicalMapping)
  sink(arg: tainted.decomposedStringWithCanonicalMapping) // $ tainted=217
  sink(arg: clean.precomposedStringWithCompatibilityMapping)
  sink(arg: tainted.precomposedStringWithCompatibilityMapping) // $ tainted=217
  sink(arg: clean.removingPercentEncoding!)
  sink(arg: tainted.removingPercentEncoding!) // $ tainted=217

  sink(arg: clean.replacingOccurrences(of: "a", with: "b"))
  sink(arg: tainted.replacingOccurrences(of: "a", with: "b")) // $ tainted=217
  sink(arg: clean.replacingOccurrences(of: "a", with: source2())) // $ tainted=305
}

func taintThroughMutatingStringOperations() {
  var str1 = source2()
  sink(arg: str1) // $ tainted=309
  sink(arg: str1.remove(at: str1.startIndex)) // $ tainted=309
  sink(arg: str1) // $ tainted=309

  var str2 = source2()
  sink(arg: str2) // $ tainted=314
  str2.removeAll()
  sink(arg: str2) // $ SPURIOUS: tainted=314

  var str3 = source2()
  sink(arg: str3) // $ tainted=319
  str3.removeAll(where: { _ in true } )
  sink(arg: str3) // $ SPURIOUS: tainted=319

  var str4 = source2()
  sink(arg: str4) // $ tainted=324
  sink(arg: str4.removeFirst()) // $ tainted=324
  sink(arg: str4) // $ tainted=324
  str4.removeFirst(5)
  sink(arg: str4) // $ tainted=324
  sink(arg: str4.removeLast()) // $ tainted=324
  sink(arg: str4) // $ tainted=324
  str4.removeLast(5)
  sink(arg: str4) // $ tainted=324

  var str5 = source2()
  sink(arg: str5) // $ tainted=335
  str5.removeSubrange(str5.startIndex ... str5.index(str5.startIndex, offsetBy: 5))
  sink(arg: str5) // $ tainted=335

  var str6 = source2()
  sink(arg: str6) // $ tainted=340
  str6.makeContiguousUTF8()
  sink(arg: str6) // $ tainted=340

  var str7 = ""
  sink(arg: str7)
  str7.replaceSubrange((nil as Range<String.Index>?)!, with: source2())
  sink(arg: str7) // $ tainted=347
}

func source3() -> Data { return Data("") }

func taintThroughData() {
  let stringClean = String(data: Data(""), encoding: String.Encoding.utf8)
  let stringTainted = String(data: source3(), encoding: String.Encoding.utf8)

	sink(arg: stringClean!)
	sink(arg: stringTainted!) // $ tainted=355

  sink(arg: String(decoding: Data(""), as: UTF8.self))
  sink(arg: String(decoding: source3(), as: UTF8.self)) // $ tainted=361
}

func taintThroughEncodings() {
  var clean = ""
  var tainted = source2()

  clean.withUTF8({
    buffer in
    sink(arg: buffer[0])
    sink(arg: buffer.baseAddress!)
  })
  tainted.withUTF8({
    buffer in
    sink(arg: buffer[0]) // $ tainted=366
    sink(arg: buffer.baseAddress!) // $ MISSING: tainted=366
  })

  clean.withCString({
    ptr in
    sink(arg: ptr[0])
  })
  tainted.withCString({
    ptr in
    sink(arg: ptr[0]) // $ tainted=366
  })
  clean.withCString(encodedAs: UTF8.self, {
    ptr in
    sink(arg: ptr[0])
  })
  tainted.withCString(encodedAs: UTF8.self, {
    ptr in
    sink(arg: ptr[0]) // $ tainted=366
  })

  let arrayString1 = clean.cString(using: String.Encoding.utf8)!
  sink(arg: arrayString1)
  arrayString1.withUnsafeBufferPointer({
    buffer in
    sink(arg: buffer[0])
    sink(arg: String(cString: buffer.baseAddress!))
  })
  let arrayString2 = tainted.cString(using: String.Encoding.utf8)!
  sink(arg: arrayString2) // $ tainted=366
  arrayString2.withUnsafeBufferPointer({
    buffer in
    sink(arg: buffer[0]) // $ tainted=366
    sink(arg: String(cString: buffer.baseAddress!)) // $ MISSING: tainted=366
  })

  clean.withPlatformString({
    ptr in
    sink(arg: ptr[0])
    sink(arg: String(platformString: ptr))

    let buffer = UnsafeBufferPointer(start: ptr, count: 10)
    let arrayString = Array(buffer)
    sink(arg: buffer[0])
    sink(arg: arrayString[0])
    sink(arg: String(platformString: arrayString))
  })
  tainted.withPlatformString({
    ptr in
    sink(arg: ptr[0]) // $ tainted=366
    sink(arg: String(platformString: ptr)) // $ tainted=366

    let buffer = UnsafeBufferPointer(start: ptr, count: 10)
    let arrayString = Array(buffer)
    sink(arg: buffer[0]) // $ MISSING: tainted=366
    sink(arg: arrayString[0]) // $ MISSING: tainted=366
    sink(arg: String(platformString: arrayString)) // $ MISSING: tainted=366
  })

  clean.withContiguousStorageIfAvailable({
    ptr in
    sink(arg: ptr[0])
    sink(arg: ptr.baseAddress!)
  })
  tainted.withContiguousStorageIfAvailable({
    ptr in
    sink(arg: ptr[0]) // $ tainted=366
    sink(arg: ptr.baseAddress!) // $ MISSING: tainted=366
  })
}

func source4() -> UInt8 { return 0 }

func taintFromUInt8Array() {
  var cleanUInt8Values: [UInt8] = [0x41, 0x42, 0x43, 0] // "ABC"
  var taintedUInt8Values: [UInt8] = [source4()]

  sink(arg: taintedUInt8Values[0]) // $ tainted=450
  let r1 = String(unsafeUninitializedCapacity: 256, initializingUTF8With: {
    (buffer: UnsafeMutableBufferPointer<UInt8>) -> Int in
      sink(arg: buffer[0])
      let _ = buffer.initialize(from: cleanUInt8Values)
      sink(arg: buffer[0])
      return 3
    }
  )
  sink(arg: r1)
  let r2 = String(unsafeUninitializedCapacity: 256, initializingUTF8With: {
    (buffer: UnsafeMutableBufferPointer<UInt8>) -> Int in
      sink(arg: buffer[0])
      sink(arg: taintedUInt8Values[0]) // $ tainted=450
      let _ = buffer.initialize(from: taintedUInt8Values)
      sink(arg: buffer[0]) // $ tainted=450
      return 256
    }
  )
  sink(arg: r2) // $ tainted=450
  let r3 = String(unsafeUninitializedCapacity: 256, initializingUTF8With: {
    (buffer: UnsafeMutableBufferPointer<UInt8>) -> Int in
      sink(arg: buffer[0])
      buffer.update(repeating: source4())
      sink(arg: buffer[0]) // $ tainted=475
      return 256
    }
  )
  sink(arg: r3) // $ tainted=475

  sink(arg: String(bytes: cleanUInt8Values, encoding: String.Encoding.utf8)!)
  sink(arg: String(bytes: taintedUInt8Values, encoding: String.Encoding.utf8)!) // $ tainted=450
  sink(arg: String(cString: cleanUInt8Values))
  sink(arg: String(cString: taintedUInt8Values)) // $ tainted=450

  try! cleanUInt8Values.withUnsafeBufferPointer({
    (buffer: UnsafeBufferPointer<UInt8>) throws in
    sink(arg: buffer[0])
    sink(arg: buffer.baseAddress!)
    sink(arg: String(cString: buffer.baseAddress!))
  })
  try! taintedUInt8Values.withUnsafeBufferPointer({
    (buffer: UnsafeBufferPointer<UInt8>) throws in
    sink(arg: buffer[0]) // $ tainted=450
    sink(arg: buffer.baseAddress!) // $ MISSING: tainted=450
    sink(arg: String(cString: buffer.baseAddress!)) // $ MISSING: tainted=450
  })
  try! cleanUInt8Values.withUnsafeMutableBytes({
    (buffer: UnsafeMutableRawBufferPointer) throws in
    sink(arg: buffer[0])
    sink(arg: buffer.baseAddress!)
    sink(arg: String(bytesNoCopy: buffer.baseAddress!, length: buffer.count, encoding: String.Encoding.utf8, freeWhenDone: false)!)
  })
  try! taintedUInt8Values.withUnsafeMutableBytes({
    (buffer: UnsafeMutableRawBufferPointer) throws in
    sink(arg: buffer[0]) // $ tainted=450
    sink(arg: buffer.baseAddress!) // $ MISSING: tainted=450
    sink(arg: String(bytesNoCopy: buffer.baseAddress!, length: buffer.count, encoding: String.Encoding.utf8, freeWhenDone: false)!) // $ MISSING: tainted=450
  })
}

func source5() -> CChar { return 0 }

func taintThroughCCharArray() {
  let cleanCCharValues: [CChar] = [0x41, 0x42, 0x43, 0]
  let taintedCCharValues: [CChar] = [source5()]

  cleanCCharValues.withUnsafeBufferPointer({
    ptr in
    sink(arg: ptr[0])
    sink(arg: ptr.baseAddress!)
    sink(arg: String(utf8String: ptr.baseAddress!)!)
    sink(arg: String(validatingUTF8: ptr.baseAddress!)!)
    sink(arg: String(cString: ptr.baseAddress!))
  })
  taintedCCharValues.withUnsafeBufferPointer({
    ptr in
    sink(arg: ptr[0]) // $ tainted=517
    sink(arg: ptr.baseAddress!) // $ MISSING: tainted=517
    sink(arg: String(utf8String: ptr.baseAddress!)!) // $ MISSING: tainted=517
    sink(arg: String(validatingUTF8: ptr.baseAddress!)!) // $ MISSING: tainted=517
    sink(arg: String(cString: ptr.baseAddress!)) // $ MISSING: tainted=517
  })

  sink(arg: String(cString: cleanCCharValues))
  sink(arg: String(cString: taintedCCharValues)) // $ tainted=517
}

func source6() -> unichar { return 0 }

func taintThroughUnicharArray() {
  let cleanUnicharValues: [unichar] = [0x41, 0x42, 0x43, 0]
  let taintedUnicharValues: [unichar] = [source6()]

  cleanUnicharValues.withUnsafeBufferPointer({
    ptr in
    sink(arg: ptr[0])
    sink(arg: ptr.baseAddress!)
    sink(arg: String(utf16CodeUnits: ptr.baseAddress!, count: ptr.count))
    sink(arg: String(utf16CodeUnitsNoCopy: ptr.baseAddress!, count: ptr.count, freeWhenDone: false))
  })
  taintedUnicharValues.withUnsafeBufferPointer({
    ptr in
    sink(arg: ptr[0]) // $ tainted=544
    sink(arg: ptr.baseAddress!) // $ MISSING: tainted=544
    sink(arg: String(utf16CodeUnits: ptr.baseAddress!, count: ptr.count)) // $ MISSING: tainted=5344
    sink(arg: String(utf16CodeUnitsNoCopy: ptr.baseAddress!, count: ptr.count, freeWhenDone: false)) // $ MISSING: tainted=544
  })
}

func source7() -> Substring { return Substring() }

func taintThroughSubstring() {
  let tainted = source2()

  sink(arg: source7()) // $ tainted=567

  let sub1 = tainted[tainted.startIndex ..< tainted.endIndex]
  sink(arg: sub1) // $ tainted=565
  sink(arg: String(sub1)) // $ tainted=565

  let sub2 = tainted.prefix(10)
  sink(arg: sub2) // $ tainted=565
  sink(arg: String(sub2)) // $ tainted=565

  let sub3 = tainted.prefix(through: tainted.endIndex)
  sink(arg: sub3) // $ tainted=565
  sink(arg: String(sub3)) // $ tainted=565

  let sub4 = tainted.prefix(upTo: tainted.endIndex)
  sink(arg: sub4) // $ tainted=565
  sink(arg: String(sub4)) // $ tainted=565

  let sub5 = tainted.suffix(10)
  sink(arg: sub5) // $ tainted=565
  sink(arg: String(sub5)) // $ tainted=565

  let sub6 = tainted.suffix(from: tainted.startIndex)
  sink(arg: sub6) // $ tainted=565
  sink(arg: String(sub6)) // $ tainted=565
}

func taintedThroughConversion() {
  sink(arg: String(0))
  sink(arg: String(source())) // $ tainted=596

  sink(arg: Int(0).description)
  sink(arg: source().description) // $ tainted=599

  sink(arg: String(describing: 0))
  sink(arg: String(describing: source())) // $ tainted=602

  sink(arg: Int("123")!)
  sink(arg: Int(source2())!) // $ tainted=605
}

func untaintedFields() {
  let tainted = source2()

  sink(arg: String.availableStringEncodings)
  sink(arg: String.defaultCStringEncoding)
  sink(arg: tainted.isContiguousUTF8)
}

func callbackWithCleanPointer(ptr: UnsafeBufferPointer<String.Element>) throws -> Int {
  sink(arg: ptr[0])

  return 0
}

func callbackWithTaintedPointer(ptr: UnsafeBufferPointer<String.Element>) throws -> Int {
  sink(arg: ptr[0]) // $ tainted=630

  return source()
}

func furtherTaintThroughCallbacks() {
  let clean = ""
  let tainted = source2()

  // return values from the closure (1)
  let result1 = clean.withContiguousStorageIfAvailable({
    ptr in
    return 0
  })
  sink(arg: result1!)
  let result2 = clean.withContiguousStorageIfAvailable({
    ptr in
    return source()
  })
  sink(arg: result2!) // $ tainted=640

  // return values from the closure (2)
  if let result3 = clean.withContiguousStorageIfAvailable({
    ptr in
    return 0
  }) {
    sink(arg: result3)
  }
  if let result4 = clean.withContiguousStorageIfAvailable({
    ptr in
    return source()
  }) {
    sink(arg: result4) // $ tainted=653
  }

  // using a non-closure function
  let result5 = try? clean.withContiguousStorageIfAvailable(callbackWithCleanPointer)
  sink(arg: result5!)
  let result6 = try? tainted.withContiguousStorageIfAvailable(callbackWithTaintedPointer)
  sink(arg: result6!) // $ tainted=625
}

func testAppendingFormat() {
  var s1 = source2()
  sink(arg: s1.appendingFormat("%s %i", "", 0)) // $ tainted=666

  var s2 = ""
  sink(arg: s2.appendingFormat(source2(), "", 0)) // $ tainted=670

  var s3 = ""
  sink(arg: s3.appendingFormat("%s %i", source2(), 0)) // $ tainted=673

  var s4 = ""
  sink(arg: s4.appendingFormat("%s %i", "", source())) // $ tainted=676
}

func sourceUInt8() -> UInt8 { return 0 }

func testDecodeCString() {
  var input : [UInt8] = [1, 2, 3, sourceUInt8()]

  let (str1, repaired1) = String.decodeCString(input, as: UTF8.self)!
  sink(arg: str1) // $ tainted=682
  sink(arg: repaired1)

  input.withUnsafeBufferPointer({
    ptr in
    let (str2, repaired2) = String.decodeCString(ptr.baseAddress, as: UTF8.self)!
    sink(arg: str2) // $ MISSING: tainted=682
    sink(arg: repaired2)
  })

  let (str3, repaired3) = String.decodeCString(source2(), as: UTF8.self)!
  sink(arg: str3) // $ tainted=695
  sink(arg: repaired3)

  let (str4, repaired4) = String.decodeCString(&input, as: UTF8.self)!
  sink(arg: str4) // $ tainted=682
  sink(arg: repaired4)
}

func testSubstringMembers() {
  let clean = ""
  let tainted = source2()

  let sub1 = tainted[..<tainted.index(tainted.endIndex, offsetBy: -5)]
  sink(arg: sub1) // $ tainted=706
  sink(arg: sub1.base) // $ tainted=706
  sink(arg: sub1.utf8) // $ tainted=706
  sink(arg: sub1.capitalized) // $ tainted=706
  sink(arg: sub1.description) // $ tainted=706

  var sub2 = tainted[tainted.index(tainted.startIndex, offsetBy: 5)...]
  sink(arg: sub2) // $ tainted=706
  let result1 = sub2.withUTF8({
    buffer in
    sink(arg: buffer[0]) // $ tainted=706
    return source()
  })
  sink(arg: result1) // $ tainted=720

  let sub3 = Substring(sub2.utf8)
  sink(arg: sub3) // $ tainted=706

  var sub4 = clean.prefix(10)
  sink(arg: sub4)
  sub4.replaceSubrange(..<clean.endIndex, with: sub1)
  sink(arg: sub4) // $ tainted=706
}

// ---

func taintMutableCharacters() {
  var str = ""

  sink(arg: str)
  let rtn = str.withMutableCharacters({
    chars in
    sink(arg: chars)
    chars.append(source2())
    sink(arg: chars) // $ tainted=742
    return source()
  })
  sink(arg: rtn) // $ tainted=744
  sink(arg: str) // $ tainted=742
}
