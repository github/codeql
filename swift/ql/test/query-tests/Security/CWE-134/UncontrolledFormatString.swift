
// --- stubs ---

struct URL
{
    init?(string: String) {}
}

struct Locale {
}

extension String : CVarArg {
    public var _cVarArgEncoding: [Int] { get { return [] } }

    init(contentsOf: URL) throws { self.init() }
    init(format: String, _ arguments: CVarArg...) { self.init() }
    init(format: String, arguments: [CVarArg]) { self.init() }
    init(format: String, locale: Locale?, _ args: CVarArg...) { self.init() }
    init(format: String, locale: Locale?, arguments: [CVarArg]) { self.init() }

    static func localizedStringWithFormat(_ format: String, _ arguments: CVarArg...) -> String { return "" }
}

extension StringProtocol {
    func appendingFormat<T>(_ format: T, _ arguments: CVarArg...) -> String where T : StringProtocol { return "" }
}

class NSObject
{
}

class NSString : NSObject
{
    init(string aString: String) {}
    init(format: NSString, _ args: CVarArg...) {}

    class func localizedStringWithFormat(_ format: NSString, _ args: CVarArg...) {}
}

class NSMutableString : NSString
{
    func appendFormat(_ format: NSString, _ args: CVarArg...) {}
}

struct NSExceptionName {
    init(_ rawValue: String) {}
}

class NSException: NSObject
{
    class func raise(_ name: NSExceptionName, format: String, arguments argList: CVaListPointer) {}
}

func NSLog(_ format: String, _ args: CVarArg...) {}

func NSLogv(_ format: String, _ args: CVaListPointer) {}

func getVaList(_ args: [CVarArg]) -> CVaListPointer { return (nil as CVaListPointer?)! }

// not a (normal) formatting function
class NSPredicate {
    init(format: String, _: CVarArg...) {}
}

// imported from C
typealias FILE = Int32 // this is a simplification
typealias wchar_t = Int32
typealias locale_t = OpaquePointer
func dprintf(_ fd: Int, _ format: UnsafePointer<Int8>, _ args: CVarArg...) -> Int32 { return 0 }
func vprintf(_ format: UnsafePointer<CChar>, _ arg: CVaListPointer) -> Int32 { return 0 }
func vfprintf(_ file: UnsafeMutablePointer<FILE>?, _ format: UnsafePointer<CChar>?, _ arg: CVaListPointer) -> Int32 { return 0 }
func vasprintf_l(_ ret: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?, _ loc: locale_t?, _ format: UnsafePointer<CChar>?, _ ap: CVaListPointer) -> Int32 { return 0 }


// --- tests ---

func MyLog(_ format: String, _ args: CVarArg...) {
    withVaList(args) { arglist in
        NSLogv(format, arglist) // $ Alert
    }
}

func myFormatMessage(string: String, _ args: CVarArg...) { }

class MyString {
    init(format: String, _ args: CVarArg...) { }
    init(formatString: String, _ args: CVarArg...) { }
}

func tests() throws {
    let tainted = try! String(contentsOf: URL(string: "http://example.com")!) // $ Source

    _ = String("abc") // GOOD: not a format string
    _ = String(tainted) // GOOD: not a format string

    _ = String(format: "abc") // GOOD: not tainted
    _ = String(format: tainted) // $ Alert
    _ = String(format: "%s", "abc") // GOOD: not tainted
    _ = String(format: "%s", tainted) // GOOD: format string itself is not tainted
    _ = String(format: tainted, "abc") // $ Alert
    _ = String(format: tainted, tainted) // $ Alert

    _ = String(format: tainted, arguments: []) // $ Alert
    _ = String(format: tainted, locale: nil) // $ Alert
    _ = String(format: tainted, locale: nil, arguments: []) // $ Alert
    _ = String.localizedStringWithFormat(tainted) // $ Alert

    _ = NSString(format: NSString(string: tainted), "abc") // $ Alert
    NSString.localizedStringWithFormat(NSString(string: tainted)) // $ Alert

    _ = NSMutableString(format: NSString(string: tainted), "abc") // $ Alert
    NSMutableString.localizedStringWithFormat(NSString(string: tainted)) // $ Alert

    NSLog("abc") // GOOD: not tainted
    NSLog(tainted) // $ Alert
    MyLog(tainted) // $ Alert

    NSException.raise(NSExceptionName("exception"), format: tainted, arguments: getVaList([])) // $ Alert

    let taintedVal = Int(tainted)!
    let taintedSan = "\(taintedVal)"
    _ = String(format: taintedSan) // GOOD: sufficiently sanitized

    let taintedVal2 = Int(tainted) ?? 0
    let taintedSan2 = String(taintedVal2)
    _ = String(format: taintedSan2) // GOOD: sufficiently sanitized

    _ = String("abc").appendingFormat("%s", "abc") // GOOD: not tainted
    _ = String("abc").appendingFormat("%s", tainted) // GOOD: format not tainted
    _ = String("abc").appendingFormat(tainted, "abc") // $ Alert
    _ = String(tainted).appendingFormat("%s", "abc") // GOOD: format not tainted

    let s = NSMutableString(string: "foo")
    s.appendFormat(NSString(string: "%s"), "abc") // GOOD: not tainted
    s.appendFormat(NSString(string: tainted), "abc") // $ Alert

    _ = NSPredicate(format: tainted) // GOOD: this should be flagged by `swift/predicate-injection`, not `swift/uncontrolled-format-string`

    tainted.withCString({
        cstr in
        _ = dprintf(0, cstr, "abc") // $ Alert
        _ = dprintf(0, "%s", cstr) // GOOD: format not tainted
        _ = vprintf(cstr, getVaList(["abc"])) // $ Alert
        _ = vprintf("%s", getVaList([cstr])) // GOOD: format not tainted
        _ = vfprintf(nil, cstr, getVaList(["abc"])) // $ Alert
        _ = vfprintf(nil, "%s", getVaList([cstr])) // GOOD: format not tainted
        _ = vasprintf_l(nil, nil, cstr, getVaList(["abc"])) // $ Alert
        _ = vasprintf_l(nil, nil, "%s", getVaList([cstr])) // GOOD: format not tainted
    })

    myFormatMessage(string: tainted, "abc") // BAD [NOT DETECTED]
    myFormatMessage(string: "%s", tainted) // GOOD: format not tainted

    _ = MyString(format: tainted, "abc") // $ Alert
    _ = MyString(format: "%s", tainted) // GOOD: format not tainted
    _ = MyString(formatString: tainted, "abc") // $ Alert
    _ = MyString(formatString: "%s", tainted) // GOOD: format not tainted
}
