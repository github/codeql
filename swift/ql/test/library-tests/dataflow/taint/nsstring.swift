
// --- stubs ---

typealias unichar = UInt16

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
  struct EncodingConversionOptions : OptionSet {
    let rawValue: Int
  }

  struct CompareOptions : OptionSet {
    let rawValue: Int
  }

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

  class func localizedStringWithFormat(_ format: NSString, _ args: CVarArg) -> Self { return (nil as Self?)! }
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
}

class NSMutableString: NSString {
  func append(_ aString: String) {}
  func insert(_ aString: String, at loc: Int) {}
  func replaceCharacters(in range: NSRange, with aString: String) {}
  func replaceOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions = [], range searchRange: NSRange) -> Int { return 0 }
  func setString(_ aString: String) {}
}

class NSArray : NSObject {
}

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

func sink(arg: Any) {}

func taintThroughInterpolatedStrings() {
  // simple initializers

  sink(arg: NSString(characters: sourceUnicharString(), length: 512)) // $ MISSING: tainted=
  sink(arg: NSString(charactersNoCopy: sourceMutableUnicharString(), length: 512, freeWhenDone: false)) // $ MISSING: tainted=
  sink(arg: NSString(string: sourceString())) // $ MISSING: tainted=
  sink(arg: NSString(format: sourceString(), arguments: (nil as CVaListPointer?)!)) // $ MISSING: tainted=
  sink(arg: NSString(format: sourceString(), locale: nil, arguments: (nil as CVaListPointer?)!)) // $ MISSING: tainted=
  sink(arg: NSString(format: sourceNSString())) // $ MISSING: tainted=
  sink(arg: NSString(format: sourceNSString(), locale: nil)) // $ MISSING: tainted=

  // initializers that can throw

  sink(arg: try! NSString(contentsOfFile: sourceString(), encoding: 0)) // $ MISSING: tainted=
  sink(arg: try! NSString(contentsOfFile: sourceString(), usedEncoding: nil)) // $ MISSING: tainted=
  sink(arg: try! NSString(contentsOf: sourceURL(), encoding: 0)) // $ MISSING: tainted=
  sink(arg: try! NSString(contentsOf: URL(string: sourceString())!, encoding: 0)) // $ MISSING: tainted=
  sink(arg: try! NSString(contentsOf: sourceURL(), usedEncoding: nil)) // $ MISSING: tainted=
  sink(arg: try! NSString(contentsOf: URL(string: sourceString())!, usedEncoding: nil)) // $ MISSING: tainted=

  // initializers returning an optional

  sink(arg: NSString(bytes: sourceUnsafeRawPointer(), length: 1024, encoding: 0)) // $ MISSING: tainted=
  sink(arg: NSString(bytes: sourceUnsafeRawPointer(), length: 1024, encoding: 0)!) // $ MISSING: tainted=
  sink(arg: NSString(bytes: UnsafeRawPointer(sourceUnsafeMutableRawPointer()), length: 1024, encoding: 0)!) // $ MISSING: tainted=

  sink(arg: NSString(bytesNoCopy: sourceUnsafeMutableRawPointer(), length: 1024, encoding: 0, freeWhenDone: false)) // $ MISSING: tainted=
  sink(arg: NSString(bytesNoCopy: sourceUnsafeMutableRawPointer(), length: 1024, encoding: 0, freeWhenDone: false)!) // $ MISSING: tainted=
  sink(arg: NSString(bytesNoCopy: UnsafeMutableRawPointer(mutating: sourceUnsafeRawPointer()), length: 1024, encoding: 0, freeWhenDone: false)!) // $ MISSING: tainted=

  sink(arg: NSString(cString: sourceCString(), encoding: 0)) // $ MISSING: tainted=
  sink(arg: NSString(cString: sourceCString(), encoding: 0)!) // $ MISSING: tainted=
  sink(arg: NSString(cString: sourceUnsafeRawPointer().bindMemory(to: CChar.self, capacity: 1024), encoding: 0)!) // $ MISSING: tainted=

  sink(arg: NSString(cString: sourceCString())) // $ MISSING: tainted=
  sink(arg: NSString(cString: sourceCString())!) // $ MISSING: tainted=
  sink(arg: NSString(cString: sourceUnsafeRawPointer().bindMemory(to: CChar.self, capacity: 1024))!) // $ MISSING: tainted=

  sink(arg: NSString(utf8String: sourceCString())) // $ MISSING: tainted=
  sink(arg: NSString(utf8String: sourceCString())!) // $ MISSING: tainted=
  sink(arg: NSString(utf8String: sourceUnsafeRawPointer().bindMemory(to: CChar.self, capacity: 1024))!) // $ MISSING: tainted=

  sink(arg: NSString(data: sourceData(), encoding: 0)) // $ MISSING: tainted=
  sink(arg: NSString(data: sourceData(), encoding: 0)!) // $ MISSING: tainted=
  sink(arg: NSString(data: Data(bytes: sourceUnsafeRawPointer(), count: 1024), encoding: 0)!) // $ MISSING: tainted=

  sink(arg: NSString(contentsOfFile: sourceString())) // $ MISSING: tainted=
  sink(arg: NSString(contentsOfFile: sourceString())!) // $ MISSING: tainted=

  sink(arg: NSString(contentsOf: sourceURL())) // $ MISSING: tainted=
  sink(arg: NSString(contentsOf: sourceURL())!) // $ MISSING: tainted=

  // simple methods (taint flow to return value)

  let harmless = NSString(string: "harmless")
  let myRange = NSRange(location:0, length: 128)

  sink(arg: NSString.localizedStringWithFormat(sourceNSString(), (nil as CVarArg?)!)) // $ MISSING: tainted=
  sink(arg: sourceNSString().character(at: 0)) // $ MISSING: tainted=
  sink(arg: sourceNSString().cString(using: 0)!) // $ MISSING: tainted=
  sink(arg: sourceNSString().cString()) // $ MISSING: tainted=
  sink(arg: sourceNSString().lossyCString()) // $ MISSING: tainted=
  sink(arg: sourceNSString().padding(toLength: 256, withPad: " ", startingAt: 0)) // $ MISSING: tainted=
  sink(arg: harmless.padding(toLength: 256, withPad: sourceString(), startingAt: 0)) // $ MISSING: tainted=
  sink(arg: sourceNSString().lowercased(with: nil)) // $ MISSING: tainted=
  sink(arg: sourceNSString().uppercased(with: nil)) // $ MISSING: tainted=
  sink(arg: sourceNSString().capitalized(with: nil)) // $ MISSING: tainted=
  sink(arg: sourceNSString().components(separatedBy: ",")) // $ MISSING: tainted=
  sink(arg: sourceNSString().components(separatedBy: ",")[0]) // $ MISSING: tainted=
  sink(arg: sourceNSString().components(separatedBy: CharacterSet.whitespaces)) // $ MISSING: tainted=
  sink(arg: sourceNSString().components(separatedBy: CharacterSet.whitespaces)[0]) // $ MISSING: tainted=
  sink(arg: sourceNSString().trimmingCharacters(in: CharacterSet.whitespaces)) // $ MISSING: tainted=
  sink(arg: sourceNSString().substring(from: 0)) // $ MISSING: tainted=
  sink(arg: sourceNSString().substring(with: myRange)) // $ MISSING: tainted=
  sink(arg: sourceNSString().substring(to: 80)) // $ MISSING: tainted=
  sink(arg: sourceNSString().folding(locale: nil)) // $ MISSING: tainted=
  sink(arg: sourceNSString().applyingTransform(StringTransform.toLatin, reverse: false)) // $ MISSING: tainted=
  sink(arg: sourceNSString().propertyList()) // $ MISSING: tainted=
  sink(arg: sourceNSString().propertyListFromStringsFileFormat()) // $ MISSING: tainted=
  sink(arg: sourceNSString().variantFittingPresentationWidth(80)) // $ MISSING: tainted=
  sink(arg: sourceNSString().data(using: 0)) // $ MISSING: tainted=
  sink(arg: sourceNSString().data(using: 0, allowLossyConversion: false)) // $ MISSING: tainted=
  sink(arg: NSString.path(withComponents: ["a", "b", "c"])) // $ MISSING: tainted=
  sink(arg: NSString.path(withComponents: sourceStringArray())) // $ MISSING: tainted=
  sink(arg: NSString.path(withComponents: ["a", sourceString(), "c"])) // $ MISSING: tainted=
  sink(arg: NSString.string(withCString: sourceCString())) // $ MISSING: tainted=
  sink(arg: NSString.string(withCString: sourceCString(), length: 128)) // $ MISSING: tainted=
  sink(arg: NSString.string(withContentsOfFile: sourceString())) // $ MISSING: tainted=
  sink(arg: NSString.string(withContentsOf: sourceURL())) // $ MISSING: tainted=

  // appending

  sink(arg: harmless.appendingFormat(harmless, (nil as CVarArg?)!))
  sink(arg: harmless.appendingFormat(sourceNSString(), (nil as CVarArg?)!)) // $ MISSING: tainted=
  sink(arg: sourceNSString().appendingFormat(harmless, (nil as CVarArg?)!)) // $ MISSING: tainted=

  sink(arg: harmless.appendingPathComponent(""))
  sink(arg: harmless.appendingPathComponent(sourceString())) // $ MISSING: tainted=
  sink(arg: sourceNSString().appendingPathComponent("")) // $ MISSING: tainted=

  sink(arg: harmless.appendingPathComponent("", conformingTo: (nil as UTType?)!))
  sink(arg: harmless.appendingPathComponent(sourceString(), conformingTo: (nil as UTType?)!)) // $ MISSING: tainted=
  sink(arg: sourceNSString().appendingPathComponent("", conformingTo: (nil as UTType?)!)) // $ MISSING: tainted=

  sink(arg: harmless.appendingPathExtension(""))
  sink(arg: harmless.appendingPathExtension(sourceString())) // $ MISSING: tainted=
  sink(arg: sourceNSString().appendingPathExtension("")) // $ MISSING: tainted=

  var str1 = harmless
  sink(arg: str1)
  str1.appending("")
  sink(arg: str1)
  str1.appending(sourceString())
  sink(arg: str1) // $ MISSING: tainted=
  str1.appending("")
  sink(arg: str1) // $ MISSING: tainted=

  sink(arg: harmless.strings(byAppendingPaths: [""]))
  sink(arg: harmless.strings(byAppendingPaths: [""])[0])
  sink(arg: harmless.strings(byAppendingPaths: [sourceString()])) // $ MISSING: tainted=
  sink(arg: harmless.strings(byAppendingPaths: [sourceString()])[0]) // $ MISSING: tainted=
  sink(arg: sourceNSString().strings(byAppendingPaths: [""])) // $ MISSING: tainted=
  sink(arg: sourceNSString().strings(byAppendingPaths: [""])[0]) // $ MISSING: tainted=

  // other methods

  var ptr1 = (nil as UnsafeMutablePointer<unichar>?)!
  sink(arg: ptr1)
  harmless.getCharacters(ptr1, range: myRange)
  sink(arg: ptr1)
  sourceNSString().getCharacters(ptr1, range: myRange)
  sink(arg: ptr1) // $ MISSING: tainted=

  var ptr2 = (nil as UnsafeMutablePointer<unichar>?)!
  sink(arg: ptr2)
  harmless.getCharacters(ptr2)
  sink(arg: ptr2)
  sourceNSString().getCharacters(ptr2)
  sink(arg: ptr2) // $ MISSING: tainted=

  var ptr3 = (nil as UnsafeMutableRawPointer?)!
  sink(arg: ptr3)
  harmless.getBytes(ptr3, maxLength: 128, usedLength: nil, encoding: 0, range: myRange, remaining: nil)
  sink(arg: ptr3)
  sourceNSString().getBytes(ptr3, maxLength: 128, usedLength: nil, encoding: 0, range: myRange, remaining: nil)
  sink(arg: ptr3) // $ MISSING: tainted=

  var ptr4 = (nil as UnsafeMutablePointer<CChar>?)!
  sink(arg: ptr4)
  harmless.getCString(ptr4, maxLength: 128, encoding: 0)
  sink(arg: ptr4)
  sourceNSString().getCString(ptr4, maxLength: 128, encoding: 0)
  sink(arg: ptr4) // $ MISSING: tainted=

  var ptr5 = (nil as UnsafeMutablePointer<CChar>?)!
  sink(arg: ptr5)
  harmless.getCString(ptr5)
  sink(arg: ptr5)
  sourceNSString().getCString(ptr5)
  sink(arg: ptr5) // $ MISSING: tainted=

  sink(arg: harmless.enumerateLines({
    line, stop in
    sink(arg: line)
    sink(arg: stop)
  }))
  sink(arg: sourceNSString().enumerateLines({
    line, stop in
    sink(arg: line) // $ MISSING: tainted=
    sink(arg: stop)
  }))

  var str10 = sourceNSString()
  var outLongest = (nil as AutoreleasingUnsafeMutablePointer<NSString?>?)!
  var outArray = (nil as AutoreleasingUnsafeMutablePointer<NSArray?>?)!
  if (str10.completePath(into: outLongest, caseSensitive: false, matchesInto: outArray, filterTypes: nil) > 0) {
    sink(arg: outLongest) // $ MISSING: tainted=
    sink(arg: outLongest.pointee) // $ MISSING: tainted=
    sink(arg: outLongest.pointee!) // $ MISSING: tainted=
    sink(arg: outArray) // $ MISSING: tainted=
    sink(arg: outArray.pointee) // $ MISSING: tainted=
    sink(arg: outArray.pointee!) // $ MISSING: tainted=
  }

  var str11 = sourceNSString()
  var outBuffer = (nil as UnsafeMutablePointer<CChar>?)!
  if (str11.getFileSystemRepresentation(outBuffer, maxLength: 256)) {
    sink(arg: outBuffer) // $ MISSING: tainted=
    sink(arg: outBuffer.pointee) // $ MISSING: tainted=
  }

  // `NSObject` methods

  var str20 = sourceNSString()

  sink(arg: str20.copy()) // $ MISSING: tainted=
  sink(arg: str20.mutableCopy()) // $ MISSING: tainted=
  sink(arg: str20.copy(with: nil)) // $ MISSING: tainted=
  sink(arg: str20.mutableCopy(with: nil)) // $ MISSING: tainted=

  // `NSMutableString` methods

  sink(arg: sourceNSMutableString().capitalized(with: nil)) // $ MISSING: tainted=

  var str30 = NSMutableString(string: "")
  sink(arg: str30)
  str30.append(sourceString())
  sink(arg: str30) // $ MISSING: tainted=

  var str31 = NSMutableString(string: "")
  sink(arg: str31)
  str31.insert(sourceString(), at: 0)
  sink(arg: str31) // $ MISSING: tainted=

  var str32 = NSMutableString(string: "")
  sink(arg: str32)
  str32.replaceCharacters(in: myRange, with: sourceString())
  sink(arg: str32) // $ MISSING: tainted=

  var str33 = NSMutableString(string: "")
  sink(arg: str33)
  str33.replaceOccurrences(of: "a", with: sourceString(), range: myRange)
  sink(arg: str33) // $ MISSING: tainted=

  var str34 = NSMutableString(string: "")
  sink(arg: str34)
  str34.setString(sourceString())
  sink(arg: str34) // $ MISSING: tainted=
  str34.append("-append")
  sink(arg: str34) // $ MISSING: tainted=
  str34.setString("")
  sink(arg: str34)
}
