
// --- stubs ---

typealias unichar = UInt16

struct AutoreleasingUnsafeMutablePointer<Pointee> {
  var pointee: Pointee { get { return (0 as! Pointee?)! } nonmutating set { } }
}

class NSObject {
  func copy() -> Any { return 0 }
  func mutableCopy() -> Any { return 0 }
}

struct NSZone {
}

protocol NSCopying {
  func copy(with zone: NSZone?) -> Any
}

protocol NSMutableCopying {
  func mutableCopy(with zone: NSZone?) -> Any
}

class NSString : NSObject, NSCopying, NSMutableCopying {
  struct EncodingConversionOptions : OptionSet { let rawValue: Int }
  struct CompareOptions : OptionSet { let rawValue: Int }
  struct EnumerationOptions : OptionSet { let rawValue: Int }

  init(characters: UnsafePointer<unichar>, length: Int) {}
  init(charactersNoCopy characters: UnsafeMutablePointer<unichar>, length: Int, freeWhenDone freeBuffer: Bool) {}
  init(string aString: String) {}

  convenience init(format: String, arguments argList: CVaListPointer) { self.init(string: "") }
  convenience init(format: String, locale: Any?, arguments argList: CVaListPointer) { self.init(string: "") }
  convenience init(format: NSString, _ args: CVarArg...) { self.init(string: "") }
  convenience init(format: NSString, locale: Locale?, _ args: CVarArg...) { self.init(string: "") }
  convenience init(contentsOfFile path: String, encoding enc: UInt) throws { self.init(string: "") }
  convenience init(contentsOfFile path: String, usedEncoding enc: UnsafeMutablePointer<UInt>?) throws { self.init(string: "") }
  convenience init(contentsOf url: URL, encoding enc: UInt) throws { self.init(string: "") }
  convenience init(contentsOf url: URL, usedEncoding enc: UnsafeMutablePointer<UInt>?) throws { self.init(string: "") }
  convenience init?(bytes: UnsafeRawPointer, length len: Int, encoding: UInt) { self.init(string: "") }
  convenience init?(bytesNoCopy bytes: UnsafeMutableRawPointer, length len: Int, encoding: UInt, freeWhenDone freeBuffer: Bool) { self.init(string: "") }
  convenience init?(cString nullTerminatedCString: UnsafePointer<CChar>, encoding: UInt) { self.init(string: "") }
  convenience init?(cString bytes: UnsafePointer<CChar>) { self.init(string: "") }
  convenience init?(utf8String nullTerminatedCString: UnsafePointer<CChar>) { self.init(string: "") }
  convenience init?(data: Data, encoding: UInt) { self.init(string: "") }
  convenience init?(contentsOfFile path: String) { self.init(string: "") }
  convenience init?(contentsOf url: URL) { self.init(string: "") }

  func copy(with zone: NSZone? = nil) -> Any { return 0 }
  func mutableCopy(with zone: NSZone? = nil) -> Any { return 0 }

  class func localizedStringWithFormat(_ format: NSString, _ args: CVarArg...) -> Self { return (nil as Self?)! }
  class func path(withComponents components: [String]) -> String { return "" }
  class func string(withCString bytes: UnsafePointer<CChar>) -> Any? { return nil }
  class func string(withCString bytes: UnsafePointer<CChar>, length: Int) -> Any? { return nil }
  class func string(withContentsOfFile path: String) -> Any? { return nil }
  class func string(withContentsOf url: URL) -> Any? { return nil }

  func character(at index: Int) -> unichar { return 0 }
  func getCharacters(_ buffer: UnsafeMutablePointer<unichar>, range: NSRange) {}
  func getCharacters(_ buffer: UnsafeMutablePointer<unichar>) {}
  func getBytes(_ buffer: UnsafeMutableRawPointer?, maxLength maxBufferCount: Int, usedLength usedBufferCount: UnsafeMutablePointer<Int>?, encoding: UInt, options: NSString.EncodingConversionOptions = [], range: NSRange, remaining leftover: NSRangePointer?) -> Bool { return true }
  func cString(using encoding: UInt) -> UnsafePointer<CChar>? { return nil }
  func cString() -> UnsafePointer<CChar>? { return nil }
  func lossyCString() -> UnsafePointer<CChar>? { return nil }
  func getCString(_ buffer: UnsafeMutablePointer<CChar>, maxLength maxBufferCount: Int, encoding: UInt) -> Bool { return false }
  func getCString(_ bytes: UnsafeMutablePointer<CChar>) {}
  func appendingFormat(_ format: NSString, _ args: CVarArg...) -> NSString { return NSString(string: "") }
  func appending(_ aString: String) -> String { return "" }
  func padding(toLength newLength: Int, withPad padString: String, startingAt padIndex: Int) -> String { return "" }
  func lowercased(with locale: Locale?) -> String { return "" }
  func uppercased(with locale: Locale?) -> String { return "" }
  func capitalized(with locale: Locale?) -> String { return "" }
  func components(separatedBy separator: String) -> [String] { return [] }
  func components(separatedBy separator: CharacterSet) -> [String] { return [] }
  func trimmingCharacters(in set: CharacterSet) -> String { return "" }
  func substring(from: Int) -> String { return "" }
  func substring(with range: NSRange) -> String { return "" }
  func substring(to: Int) -> String { return "" }
  func folding(options: NSString.CompareOptions = [], locale: Locale?) -> String { return "" }
  func applyingTransform(_ transform: StringTransform, reverse: Bool) -> String? { return "" }
  func enumerateLines(_ block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) { }
  func enumerateSubstrings(in range: NSRange, options opts: NSString.EnumerationOptions = [], using block: @escaping (String?, NSRange, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) { }
  func replacingOccurrences(of target: String, with replacement: String) -> String { return "" }
  func replacingOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions = [], range searchRange: NSRange) -> String { return "" }
  func propertyList() -> Any { return 0 }
  func propertyListFromStringsFileFormat() -> [AnyHashable: Any]? { return nil }
  func variantFittingPresentationWidth(_ width: Int) -> String { return "" }
  func data(using encoding: UInt) -> Data? { return nil }
  func data(using encoding: UInt, allowLossyConversion lossy: Bool) -> Data? { return nil }
  func appendingPathComponent(_ str: String) -> String { return "" }
  func appendingPathComponent(_ partialName: String, conformingTo contentType: UTType) -> String { return "" }
  func appendingPathExtension(_ str: String) -> String? { return "" }
  func strings(byAppendingPaths paths: [String]) -> [String] { return [] }
  func completePath(into outputName: AutoreleasingUnsafeMutablePointer<NSString?>?, caseSensitive flag: Bool, matchesInto outputArray: AutoreleasingUnsafeMutablePointer<NSArray?>?, filterTypes: [String]?) -> Int { return 1 }
  func getFileSystemRepresentation(_ cname: UnsafeMutablePointer<CChar>, maxLength max: Int) -> Bool { return true }

  var utf8String: UnsafePointer<CChar>? { get { return nil } }
  var lowercased: String { get { return "" } }
  var localizedLowercase: String { get { return "" } }
  var uppercased: String { get { return "" } }
  var localizedUppercase: String { get { return "" } }
  var capitalized: String { get { return "" } }
  var localizedCapitalized: String { get { return "" } }
  var decomposedStringWithCanonicalMapping: String { get { return "" } }
  var decomposedStringWithCompatibilityMapping: String { get { return "" } }
  var precomposedStringWithCanonicalMapping: String { get { return "" } }
  var precomposedStringWithCompatibilityMapping: String { get { return "" } }
  var doubleValue: Double { get { return 0.0 } }
  var floatValue: Float { get { return 0.0 } }
  var intValue: Int32 { get { return 0 } }
  var integerValue: Int { get { return 0 } }
  var longLongValue: Int64 { get { return 0 } }
  var boolValue: Bool { get { return false } }
  var description: String { get { return "" } }
  var pathComponents: [String] { get { return [] } }
  var fileSystemRepresentation: UnsafePointer<CChar> { get { return (nil as UnsafePointer<CChar>?)! } }
  var lastPathComponent: String { get { return "" } }
  var pathExtension: String { get { return "" } }
  var abbreviatingWithTildeInPath: String { get { return "" } }
  var deletingLastPathComponent: String { get { return "" } }
  var deletingPathExtension: String { get { return "" } }
  var expandingTildeInPath: String { get { return "" } }
  var resolvingSymlinksInPath: String { get { return "" } }
  var standardizingPath: String { get { return "" } }
  var removingPercentEncoding: String? { get { return "" } }
}

class NSMutableString : NSString {
  func append(_ aString: String) {}
  func insert(_ aString: String, at loc: Int) {}
  func replaceCharacters(in range: NSRange, with aString: String) {}
  func replaceOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions = [], range searchRange: NSRange) -> Int { return 0 }
  func setString(_ aString: String) {}
}

class NSArray : NSObject { }

struct _NSRange {
  init(location: Int, length: Int) {}
}

typealias NSRange = _NSRange
typealias NSRangePointer = UnsafeMutablePointer<NSRange>

struct URL {
	init?(string: String) {}
}

struct Data {
  init<S>(_ elements: S) {}
  init(bytes: UnsafeRawPointer, count: Int) {}
}

struct CharacterSet {
  static var whitespaces: CharacterSet { get { return CharacterSet() } }
}

struct StringTransform {
  static var toLatin: StringTransform { get { return StringTransform() } }
}

struct Locale {
}

struct ObjCBool {
}

struct UTType {
}

// --- tests ---

func sourceString() -> String { return "" }
func sourceNSString() -> NSString { return NSString(string: "") }
func sourceNSMutableString() -> NSMutableString { return NSMutableString(string: "") }
func sourceUnicharString() -> UnsafePointer<unichar> { return (nil as UnsafePointer<unichar>?)! }
func sourceMutableUnicharString() -> UnsafeMutablePointer<unichar> { return (nil as UnsafeMutablePointer<unichar>?)! }
func sourceURL() -> URL { return URL(string: "")! }
func sourceUnsafeRawPointer() -> UnsafeRawPointer { return (nil as UnsafeRawPointer?)! }
func sourceUnsafeMutableRawPointer() -> UnsafeMutableRawPointer { return (nil as UnsafeMutableRawPointer?)! }
func sourceCString() -> UnsafePointer<CChar> { return (nil as UnsafePointer<CChar>?)! }
func sourceData() -> Data { return Data(0) }
func sourceStringArray() -> [String] { return [] }
func sourceInt() -> Int { return 0 }
func sink(arg: Any) {}

func taintThroughInterpolatedStrings() {
  // simple initializers

  sink(arg: NSString(characters: sourceUnicharString(), length: 512)) // $ tainted=194
  sink(arg: NSString(charactersNoCopy: sourceMutableUnicharString(), length: 512, freeWhenDone: false)) // $ tainted=195
  sink(arg: NSString(string: sourceString())) // $ tainted=196
  sink(arg: NSString(format: sourceString(), arguments: (nil as CVaListPointer?)!)) // $ tainted=197
  sink(arg: NSString(format: sourceString(), locale: nil, arguments: (nil as CVaListPointer?)!)) // $ tainted=198
  sink(arg: NSString(format: sourceNSString())) // $ tainted=199
  sink(arg: NSString(format: sourceNSString(), locale: nil)) // $ tainted=200

  // initializers that can throw

  sink(arg: try! NSString(contentsOfFile: sourceString(), encoding: 0)) // $ tainted=204
  sink(arg: try! NSString(contentsOfFile: sourceString(), usedEncoding: nil)) // $ tainted=205
  sink(arg: try! NSString(contentsOf: sourceURL(), encoding: 0)) // $: tainted=206
  sink(arg: try! NSString(contentsOf: URL(string: sourceString())!, encoding: 0)) // $ tainted=207
  sink(arg: try! NSString(contentsOf: sourceURL(), usedEncoding: nil)) // $ tainted=208
  sink(arg: try! NSString(contentsOf: URL(string: sourceString())!, usedEncoding: nil)) // $ tainted=209

  // initializers returning an optional

  sink(arg: NSString(bytes: sourceUnsafeRawPointer(), length: 1024, encoding: 0)) // $ tainted=213
  sink(arg: NSString(bytes: sourceUnsafeRawPointer(), length: 1024, encoding: 0)!) // $ tainted=214
  sink(arg: NSString(bytes: UnsafeRawPointer(sourceUnsafeMutableRawPointer()), length: 1024, encoding: 0)!) // $ MISSING: tainted=

  sink(arg: NSString(bytesNoCopy: sourceUnsafeMutableRawPointer(), length: 1024, encoding: 0, freeWhenDone: false)) // $ tainted=217
  sink(arg: NSString(bytesNoCopy: sourceUnsafeMutableRawPointer(), length: 1024, encoding: 0, freeWhenDone: false)!) // $ tainted=218
  sink(arg: NSString(bytesNoCopy: UnsafeMutableRawPointer(mutating: sourceUnsafeRawPointer()), length: 1024, encoding: 0, freeWhenDone: false)!) // $ MISSING: tainted=

  sink(arg: NSString(cString: sourceCString(), encoding: 0)) // $ tainted=221
  sink(arg: NSString(cString: sourceCString(), encoding: 0)!) // $ tainted=222
  sink(arg: NSString(cString: sourceUnsafeRawPointer().bindMemory(to: CChar.self, capacity: 1024), encoding: 0)!) // $ MISSING: tainted=

  sink(arg: NSString(cString: sourceCString())) // $ tainted=225
  sink(arg: NSString(cString: sourceCString())!) // $ tainted=226
  sink(arg: NSString(cString: sourceUnsafeRawPointer().bindMemory(to: CChar.self, capacity: 1024))!) // $ MISSING: tainted=

  sink(arg: NSString(utf8String: sourceCString())) // $ tainted=229
  sink(arg: NSString(utf8String: sourceCString())!) // $ tainted=230
  sink(arg: NSString(utf8String: sourceUnsafeRawPointer().bindMemory(to: CChar.self, capacity: 1024))!) // $ MISSING: tainted=

  sink(arg: NSString(data: sourceData(), encoding: 0)) // $ tainted=233
  sink(arg: NSString(data: sourceData(), encoding: 0)!) // $ tainted=234
  sink(arg: NSString(data: Data(bytes: sourceUnsafeRawPointer(), count: 1024), encoding: 0)!) // $ tainted=235

  sink(arg: NSString(contentsOfFile: sourceString())) // $ tainted=237
  sink(arg: NSString(contentsOfFile: sourceString())!) // $ tainted=238

  sink(arg: NSString(contentsOf: sourceURL())) // $ tainted=240
  sink(arg: NSString(contentsOf: sourceURL())!) // $ tainted=241

  // simple methods (taint flow to return value)

  let harmless = NSString(string: "harmless")
  let myRange = NSRange(location:0, length: 128)
  sink(arg: NSString.localizedStringWithFormat(NSString(string: "%i %i %i"), 1, sourceInt(), 3)) // $ tainted=247
  sink(arg: NSString.localizedStringWithFormat(sourceNSString(), 1, 2, 3)) // $ tainted=248
  sink(arg: sourceNSString().character(at: 0)) // $ tainted=249
  sink(arg: sourceNSString().cString(using: 0)!) // $ tainted=250
  sink(arg: sourceNSString().cString()) // $ tainted=251
  sink(arg: sourceNSString().lossyCString()) // $ tainted=252
  sink(arg: sourceNSString().padding(toLength: 256, withPad: " ", startingAt: 0)) // $ tainted=253
  sink(arg: harmless.padding(toLength: 256, withPad: sourceString(), startingAt: 0)) // $ tainted=254
  sink(arg: sourceNSString().lowercased(with: nil)) // $ tainted=255
  sink(arg: sourceNSString().uppercased(with: nil)) // $ tainted=256
  sink(arg: sourceNSString().capitalized(with: nil)) // $ tainted=257
  sink(arg: sourceNSString().components(separatedBy: ",")) // $ tainted=258
  sink(arg: sourceNSString().components(separatedBy: ",")[0]) // $ tainted=259
  sink(arg: sourceNSString().components(separatedBy: CharacterSet.whitespaces)) // $ tainted=260
  sink(arg: sourceNSString().components(separatedBy: CharacterSet.whitespaces)[0]) // $ tainted=261
  sink(arg: sourceNSString().trimmingCharacters(in: CharacterSet.whitespaces)) // $ tainted=262
  sink(arg: sourceNSString().substring(from: 0)) // $ tainted=263
  sink(arg: sourceNSString().substring(with: myRange)) // $ tainted=264
  sink(arg: sourceNSString().substring(to: 80)) // $ tainted=265
  sink(arg: sourceNSString().folding(locale: nil)) // $ tainted=266
  sink(arg: sourceNSString().applyingTransform(StringTransform.toLatin, reverse: false)) // $ tainted=267
  sink(arg: sourceNSString().propertyList()) // $ tainted=268
  sink(arg: sourceNSString().propertyListFromStringsFileFormat()) // $ tainted=269
  sink(arg: sourceNSString().variantFittingPresentationWidth(80)) // $ tainted=270
  sink(arg: sourceNSString().data(using: 0)) // $ tainted=271
  sink(arg: sourceNSString().data(using: 0, allowLossyConversion: false)) // $ tainted=272
  sink(arg: sourceNSString().replacingOccurrences(of: "a", with: "b")) // $ tainted=273
  sink(arg: harmless.replacingOccurrences(of: "a", with: sourceString())) // $ tainted=274
  sink(arg: sourceNSString().replacingOccurrences(of: "a", with: "b", range: NSRange(location: 0, length: 10))) // $ tainted=275
  sink(arg: harmless.replacingOccurrences(of: "a", with: sourceString(), range: NSRange(location: 0, length: 10))) // $ tainted=276
  sink(arg: NSString.path(withComponents: ["a", "b", "c"]))
  sink(arg: NSString.path(withComponents: sourceStringArray())) // $ MISSING: tainted=278
  sink(arg: NSString.path(withComponents: ["a", sourceString(), "c"])) // $ tainted=279
  sink(arg: NSString.string(withCString: sourceCString())) // $ tainted=280
  sink(arg: NSString.string(withCString: sourceCString(), length: 128)) // $ tainted=281
  sink(arg: NSString.string(withContentsOfFile: sourceString())) // $ tainted=282
  sink(arg: NSString.string(withContentsOf: sourceURL())) // $ tainted=283

  // appending

  sink(arg: harmless.appendingFormat(harmless, (nil as CVarArg?)!))
  sink(arg: harmless.appendingFormat(sourceNSString(), (nil as CVarArg?)!)) // $ tainted=288
  sink(arg: sourceNSString().appendingFormat(harmless, (nil as CVarArg?)!)) // $ tainted=289

  sink(arg: harmless.appendingPathComponent(""))
  sink(arg: harmless.appendingPathComponent(sourceString())) // $ tainted=292
  sink(arg: sourceNSString().appendingPathComponent("")) // $ tainted=293

  sink(arg: harmless.appendingPathComponent("", conformingTo: (nil as UTType?)!))
  sink(arg: harmless.appendingPathComponent(sourceString(), conformingTo: (nil as UTType?)!)) // $ tainted=296
  sink(arg: sourceNSString().appendingPathComponent("", conformingTo: (nil as UTType?)!)) // $ tainted=297

  sink(arg: harmless.appendingPathExtension(""))
  sink(arg: harmless.appendingPathExtension(sourceString())) // $ tainted=300
  sink(arg: sourceNSString().appendingPathExtension("")) // $ tainted=301

  sink(arg: harmless.appending(""))
  sink(arg: sourceNSString().appending("")) // $ tainted=304
  sink(arg: harmless.appending(sourceString())) // $ tainted=305

  sink(arg: harmless.strings(byAppendingPaths: [""]))
  sink(arg: harmless.strings(byAppendingPaths: [""])[0])
  sink(arg: harmless.strings(byAppendingPaths: [sourceString()])) // $ tainted=309
  sink(arg: harmless.strings(byAppendingPaths: [sourceString()])[0]) // $ tainted=310
  sink(arg: sourceNSString().strings(byAppendingPaths: [""])) // $ tainted=311
  sink(arg: sourceNSString().strings(byAppendingPaths: [""])[0]) // $ tainted=312

  // other methods

  var ptr1 = (nil as UnsafeMutablePointer<unichar>?)!
  sink(arg: ptr1)
  harmless.getCharacters(ptr1, range: myRange)
  sink(arg: ptr1)
  sourceNSString().getCharacters(ptr1, range: myRange)
  sink(arg: ptr1) // $ tainted=320

  var ptr2 = (nil as UnsafeMutablePointer<unichar>?)!
  sink(arg: ptr2)
  harmless.getCharacters(ptr2)
  sink(arg: ptr2)
  sourceNSString().getCharacters(ptr2)
  sink(arg: ptr2) // $ tainted=327

  var ptr3 = (nil as UnsafeMutableRawPointer?)!
  sink(arg: ptr3)
  harmless.getBytes(ptr3, maxLength: 128, usedLength: nil, encoding: 0, range: myRange, remaining: nil)
  sink(arg: ptr3)
  sourceNSString().getBytes(ptr3, maxLength: 128, usedLength: nil, encoding: 0, range: myRange, remaining: nil)
  sink(arg: ptr3) // $ tainted=334

  var ptr4 = (nil as UnsafeMutablePointer<CChar>?)!
  sink(arg: ptr4)
  harmless.getCString(ptr4, maxLength: 128, encoding: 0)
  sink(arg: ptr4)
  sourceNSString().getCString(ptr4, maxLength: 128, encoding: 0)
  sink(arg: ptr4) // $ tainted=341

  var ptr5 = (nil as UnsafeMutablePointer<CChar>?)!
  sink(arg: ptr5)
  harmless.getCString(ptr5)
  sink(arg: ptr5)
  sourceNSString().getCString(ptr5)
  sink(arg: ptr5) // $ tainted=348

  sink(arg: harmless.enumerateLines({
    line, stop in
    sink(arg: line)
    sink(arg: stop)
  }))
  sink(arg: sourceNSString().enumerateLines({
    line, stop in
    sink(arg: line) // $ tainted=356
    sink(arg: stop)
  }))

  var str10 = sourceNSString()
  var outLongest = (nil as AutoreleasingUnsafeMutablePointer<NSString?>?)!
  var outArray = (nil as AutoreleasingUnsafeMutablePointer<NSArray?>?)!
  if (str10.completePath(into: outLongest, caseSensitive: false, matchesInto: outArray, filterTypes: nil) > 0) {
    sink(arg: outLongest) // $ tainted=362
    sink(arg: outLongest.pointee) // $ MISSING: tainted=
    sink(arg: outLongest.pointee!) // $ MISSING: tainted=
    sink(arg: outArray) // $ tainted=362
    sink(arg: outArray.pointee) // $ MISSING: tainted=
    sink(arg: outArray.pointee!) // $ MISSING: tainted=
  }

  var str11 = sourceNSString()
  var outBuffer = (nil as UnsafeMutablePointer<CChar>?)!
  if (str11.getFileSystemRepresentation(outBuffer, maxLength: 256)) {
    sink(arg: outBuffer) // $ tainted=374
    sink(arg: outBuffer.pointee) // $ MISSING: tainted=
  }

  // `NSObject` methods

  var str20 = sourceNSString()

  sink(arg: str20.copy()) // $ tainted=383
  sink(arg: str20.mutableCopy()) // $ tainted=383
  sink(arg: str20.copy(with: nil)) // $ tainted=383
  sink(arg: str20.mutableCopy(with: nil)) // $ tainted=383

  // `NSMutableString` methods

  sink(arg: sourceNSMutableString().capitalized(with: nil)) // $ tainted=392

  var str30 = NSMutableString(string: "")
  sink(arg: str30)
  str30.append(sourceString())
  sink(arg: str30) // $ tainted=396

  var str31 = NSMutableString(string: "")
  sink(arg: str31)
  str31.insert(sourceString(), at: 0)
  sink(arg: str31) // $ tainted=401

  var str32 = NSMutableString(string: "")
  sink(arg: str32)
  str32.replaceCharacters(in: myRange, with: sourceString())
  sink(arg: str32) // $ tainted=406

  var str33 = NSMutableString(string: "")
  sink(arg: str33)
  str33.replaceOccurrences(of: "a", with: sourceString(), range: myRange)
  sink(arg: str33) // $ tainted=411

  var str34 = NSMutableString(string: "")
  sink(arg: str34)
  str34.setString(sourceString())
  sink(arg: str34) // $ tainted=416
  str34.append("-append")
  sink(arg: str34) // $ tainted=416
  str34.setString("")
  sink(arg: str34) // $ SPURIOUS: tainted=416

  // member variables

  sink(arg: sourceNSString().utf8String) // $ tainted=425
  sink(arg: NSString(utf8String: sourceNSString().utf8String!)!) // $ tainted=426
  sink(arg: sourceNSString().lowercased) // $ tainted=427
  sink(arg: sourceNSString().localizedLowercase) // $ MISSING: tainted=
  sink(arg: sourceNSString().uppercased) // $ tainted=429
  sink(arg: sourceNSString().localizedUppercase) // $ tainted=430
  sink(arg: sourceNSString().capitalized) // $ tainted=431
  sink(arg: sourceNSString().localizedCapitalized) // $ tainted=432
  sink(arg: sourceNSString().decomposedStringWithCanonicalMapping) // $ tainted=433
  sink(arg: sourceNSString().decomposedStringWithCompatibilityMapping) // $ tainted=434
  sink(arg: sourceNSString().precomposedStringWithCanonicalMapping) // $ tainted=435
  sink(arg: sourceNSString().precomposedStringWithCompatibilityMapping) // $ tainted=436
  sink(arg: sourceNSString().doubleValue) // $ tainted=437
  sink(arg: sourceNSString().floatValue) // $ tainted=438
  sink(arg: sourceNSString().intValue) // $ tainted=439
  sink(arg: sourceNSString().integerValue) // $ tainted=440
  sink(arg: sourceNSString().longLongValue) // $ tainted=441
  sink(arg: sourceNSString().boolValue) // $ tainted=442
  sink(arg: sourceNSString().description) // $ tainted=443
  sink(arg: sourceNSString().pathComponents) // $ tainted=444
  sink(arg: sourceNSString().pathComponents[0]) // $ tainted=445
  sink(arg: sourceNSString().fileSystemRepresentation) // $ tainted=446
  sink(arg: sourceNSString().lastPathComponent) // $ tainted=447
  sink(arg: sourceNSString().pathExtension) // $ tainted=448
  sink(arg: sourceNSString().abbreviatingWithTildeInPath) // $ tainted=449
  sink(arg: sourceNSString().deletingLastPathComponent) // $ tainted=450
  sink(arg: sourceNSString().deletingPathExtension) // $ tainted=451
  sink(arg: sourceNSString().expandingTildeInPath) // $ tainted=452
  sink(arg: sourceNSString().resolvingSymlinksInPath) // $ tainted=453
  sink(arg: sourceNSString().standardizingPath) // $ tainted=454
  sink(arg: sourceNSString().removingPercentEncoding) // $ tainted=455
}

extension String {
  // an artificial initializer for initializing a `String` from an `NSString`. This can be done
  // in real-world Swift, but probably involves bridging magic and one of the other initializers.
  init(_: NSString) { self.init() }
}

func taintThroughConversions() {
  // these are best effort tests as there's bridging magic between `String` and `NSString` that
  // we can't easily stub.
  let str1 = sourceString()
  let str2 = NSString(string: str1)
  sink(arg: str2) // $ tainted=467
  let str3 = str1 as! NSString // in real-world Swift you can just use `as` here
  sink(arg: str3) // $ tainted=467

  let str5 = sourceNSString()
  let str6 = String(str5)
  sink(arg: str6) // $ tainted=473
  let str7 = str5 as! String // in real-world Swift you can just use `as` here
  sink(arg: str7) // $ tainted=473
}

func taintThroughData() {
  // additional tests through the `Data` class
  let str1 = sourceNSString()
  let data1 = str1.data(using: 0)!
  sink(arg: data1) // $ tainted=482
  let str2 = NSString(data: data1, encoding: 0)!
  sink(arg: str2) // $ tainted=482
}

func moreTests() {
  let myTainted = sourceNSString()
  let myRange = NSRange(location:0, length: 128)

  sink(arg: myTainted.enumerateSubstrings(in: myRange, options: [], using: {
    substring, substringRange, enclosingRange, stop in
    sink(arg: substring!) // $ tainted=490
  }))
}
