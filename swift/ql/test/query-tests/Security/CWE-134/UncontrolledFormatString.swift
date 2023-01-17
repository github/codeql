
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

// --- tests ---

func MyLog(_ format: String, _ args: CVarArg...) {
    withVaList(args) { arglist in
        NSLogv(format, arglist) // BAD [NOT DETECTED]
    }
}

func tests() {
    let tainted = try! String(contentsOf: URL(string: "http://example.com")!)

    let a = String("abc") // GOOD: not a format string
    let b = String(tainted) // GOOD: not a format string

    let c = String(format: "abc") // GOOD: not tainted
    let d = String(format: tainted) // BAD
    let e = String(format: "%s", "abc") // GOOD: not tainted
    let f = String(format: "%s", tainted) // GOOD: format string itself is not tainted
    let g = String(format: tainted, "abc") // BAD
    let h = String(format: tainted, tainted) // BAD

    let i = String(format: tainted, arguments: []) // BAD
    let j = String(format: tainted, locale: nil) // BAD
    let k = String(format: tainted, locale: nil, arguments: []) // BAD
    let l = String.localizedStringWithFormat(tainted) // BAD

    let m = NSString(format: NSString(string: tainted), "abc") // BAD [NOT DETECTED]
    let n = NSString.localizedStringWithFormat(NSString(string: tainted)) // BAD [NOT DETECTED]

    var o = NSMutableString(format: NSString(string: tainted), "abc") // BAD [NOT DETECTED]
    var p = NSMutableString.localizedStringWithFormat(NSString(string: tainted)) // BAD [NOT DETECTED]

    NSLog("abc") // GOOD: not tainted
    NSLog(tainted) // BAD
    MyLog(tainted) // BAD [NOT DETECTED]

    NSException.raise(NSExceptionName("exception"), format: tainted, arguments: getVaList([])) // BAD

    let taintedVal = Int(tainted)!
    let taintedSan = "\(taintedVal)"
    let q = String(format: taintedSan) // GOOD: sufficiently sanitized

    let taintedVal2 = Int(tainted) ?? 0
    let taintedSan2 = String(taintedVal2)
    let r = String(format: taintedSan2) // GOOD: sufficiently sanitized
}
