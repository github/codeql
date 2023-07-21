// this test is in a separate file, because we want to test with a slightly different library
// implementation. In this version, some of the functions of `NSString` are in fact implemented
// in a base class `NSStringBase`.

// --- stubs ---

func print(_ items: Any...) {}

typealias unichar = UInt16

class NSObject
{
}

class NSString : NSObject
{
    init(string: String) { length = string.count }

    func substring(to: Int) -> String { return "" }

    private(set) var length: Int
}

extension NSString
{
    func substring(from: Int) -> String { return "" }
}

// --- tests ---

func test(s: String) {
    let ns = NSString(string: s)

    let nstr1 = ns.substring(from: ns.length - 1) // GOOD
    let nstr2 = ns.substring(from: s.count - 1) // BAD: String length used in NSString
    let nstr3 = ns.substring(to: ns.length - 1) // GOOD
    let nstr4 = ns.substring(to: s.count - 1) // BAD: String length used in NSString
    print("substrings '\(nstr1)' '\(nstr2)' / '\(nstr3)' '\(nstr4)'")
}

// `begin :thumbsup: end`, with thumbs up emoji and skin tone modifier
test(s: "begin \u{0001F44D}\u{0001F3FF} end")
