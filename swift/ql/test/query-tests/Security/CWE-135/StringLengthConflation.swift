
// --- stubs ---

func print(_ items: Any...) {}

typealias unichar = UInt16

class NSObject
{
}

class NSString : NSObject
{
    init(string: String) { length = string.count }

    func character(at: Int) -> unichar { return 0 }
    func substring(from: Int) -> String { return "" }
    func substring(to: Int) -> String { return "" }

    private(set) var length: Int
}

class NSMutableString : NSString
{
    func insert(_: String, at: Int) {}
}

class NSRange
{
    init(location: Int, length: Int) { self.description = "" }
    init<R, S>(_ r: R, in: S) { self.description = "" }

    private(set) var description: String
}

func NSMakeRange(_ loc: Int, _ len: Int) -> NSRange { return NSRange(location: loc, length: len) }



// --- tests ---

func test(s: String) {
    let ns = NSString(string: s)
    let nms = NSMutableString(string: s)

    print("'\(s)'")
    print("count \(s.count) length \(ns.length)")
    print("utf8.count \(s.utf8.count) utf16.count \(s.utf16.count) unicodeScalars.count \(s.unicodeScalars.count)")

    // --- constructing a String.Index from integer ---

    let ix1 = String.Index(encodedOffset: s.count) // GOOD
    let ix2 = String.Index(encodedOffset: ns.length) // BAD: NSString length used in String.Index
    let ix3 = String.Index(encodedOffset: s.utf8.count) // BAD: String.utf8 length used in String.Index
    let ix4 = String.Index(encodedOffset: s.utf16.count) // BAD: String.utf16 length used in String.Index
    let ix5 = String.Index(encodedOffset: s.unicodeScalars.count) // BAD: string.unicodeScalars length used in String.Index
    print("String.Index '\(ix1.encodedOffset)' / '\(ix2.encodedOffset)' '\(ix3.encodedOffset)' '\(ix4.encodedOffset)' '\(ix5.encodedOffset)'")

    let ix6 = s.index(s.startIndex, offsetBy: s.count / 2) // GOOD
    let ix7 = s.index(s.startIndex, offsetBy: ns.length / 2) // BAD: NSString length used in String.Index
    print("index '\(ix6.encodedOffset)' / '\(ix7.encodedOffset)'")

    var ix8 = s.startIndex
    s.formIndex(&ix8, offsetBy: s.count / 2) // GOOD
    var ix9 = s.startIndex
    s.formIndex(&ix9, offsetBy: ns.length / 2) // BAD: NSString length used in String.Index
    print("formIndex '\(ix8.encodedOffset)' / '\(ix9.encodedOffset)'")

    // --- constructing an NSRange from integers ---

    let range1 = NSMakeRange(0, ns.length) // GOOD
    let range2 = NSMakeRange(0, s.count) // BAD: String length used in NSMakeRange
    let range3 = NSMakeRange(0, s.reversed().count) // BAD: String length used in NSMakeRange [NOT DETECTED]
    let range4 = NSMakeRange(0, s.distance(from: s.startIndex, to: s.endIndex))  // BAD: String length used in NSMakeRange [NOT DETECTED]
    print("NSMakeRange '\(range1.description)' / '\(range2.description)' '\(range3.description)' '\(range4.description)'")

    let range5 = NSRange(location: 0, length: ns.length) // GOOD
    let range6 = NSRange(location: 0, length: s.count) // BAD: String length used in NSMakeRange
    let range7 = NSRange(location: 0, length: s.utf8.count) // BAD: String.utf8  length used in NSMakeRange
    let range8 = NSRange(location: 0, length: s.utf16.count) // GOOD: String.utf16 length and NSRange count are equivalent
    let range9 = NSRange(location: 0, length: s.unicodeScalars.count) // BAD: String.unicodeScalars length used in NSMakeRange
    print("NSRange '\(range5.description)' / '\(range6.description)' '\(range7.description)' '\(range8.description)' '\(range9.description)'")

    // --- converting Range to NSRange ---

    let range10 = s.startIndex ..< s.endIndex
    let range11 = NSRange(range10, in: s) // GOOD
    let location = s.distance(from: s.startIndex, to: range10.lowerBound)
    let length = s.distance(from: range10.lowerBound, to: range10.upperBound)
    let range12 = NSRange(location: location, length: length) // BAD [NOT DETECTED]
    print("NSRange '\(range11.description)' / '\(range12.description)'")

    // --- String operations using an integer directly ---

    let str1 = s.dropFirst(s.count - 1) // GOOD
    let str2 = s.dropFirst(ns.length - 1) // BAD: NSString length used in String
    print("dropFirst '\(str1)' / '\(str2)'")

    let str3 = s.dropLast(s.count - 1) // GOOD
    let str4 = s.dropLast(ns.length - 1) // BAD: NSString length used in String
    print("dropLast '\(str3)' / '\(str4)'")

    let str5 = s.prefix(s.count - 1) // GOOD
    let str6 = s.prefix(ns.length - 1) // BAD: NSString length used in String
    print("prefix '\(str5)' / '\(str6)'")

    let str7 = s.suffix(s.count - 1) // GOOD
    let str8 = s.suffix(ns.length - 1) // BAD: NSString length used in String
    print("suffix '\(str7)' / '\(str8)'")

    var str9 = s
    str9.removeFirst(s.count - 1) // GOOD
    var str10 = s
    str10.removeFirst(ns.length - 1) // BAD: NSString length used in String
    print("removeFirst '\(str9)' / '\(str10)'")

    var str11 = s
    str11.removeLast(s.count - 1) // GOOD
    var str12 = s
    str12.removeLast(ns.length - 1) // BAD: NSString length used in String
    print("removeLast '\(str11)' / '\(str12)'")

    let nstr1 = ns.character(at: ns.length - 1) // GOOD
    let nmstr1 = nms.character(at: nms.length - 1) // GOOD
    let nstr2 = ns.character(at: s.count - 1) // BAD: String length used in NSString
    let nmstr2 = nms.character(at: s.count - 1) // BAD: String length used in NString
    print("character '\(nstr1)' '\(nmstr1)' / '\(nstr2)' '\(nmstr2)'")

    let nstr3 = ns.substring(from: ns.length - 1) // GOOD
    let nmstr3 = nms.substring(from: nms.length - 1) // GOOD
    let nstr4 = ns.substring(from: s.count - 1) // BAD: String length used in NSString
    let nmstr4 = nms.substring(from: s.count - 1) // BAD: String length used in NString
    print("substring from '\(nstr3)' '\(nmstr3)' / '\(nstr4)' '\(nmstr4)'")

    let nstr5 = ns.substring(to: ns.length - 1) // GOOD
    let nmstr5 = nms.substring(to: nms.length - 1) // GOOD
    let nstr6 = ns.substring(to: s.count - 1) // BAD: String length used in NSString
    let nmstr6 = nms.substring(to: s.count - 1) // BAD: String length used in NString
    print("substring to '\(nstr5)' '\(nmstr5)' / '\(nstr6)' '\(nmstr6)'")

    let nmstr7 = NSMutableString(string: s)
    nmstr7.insert("*", at: nms.length - 1) // GOOD
    let nmstr8 = NSMutableString(string: s)
    nmstr8.insert("*", at: s.count - 1) // BAD: String length used in NSString
    print("insert '\(nmstr7)' / '\(nmstr8)'")

    // --- inspired by real world cases ---

    let scalars = s.unicodeScalars
    let _ = s.index(s.startIndex, offsetBy: s.count) // GOOD
    let _ = s.index(s.startIndex, offsetBy: scalars.count) // BAD
    let _ = scalars.index(scalars.startIndex, offsetBy: scalars.count) // GOOD
    let _ = scalars.index(scalars.startIndex, offsetBy: s.count) // BAD [NOT DETECTED]

    let s_utf8 = s.utf8
    let _ = s.index(s.startIndex, offsetBy: s_utf8.count) // BAD
    let _ = s_utf8.index(s_utf8.startIndex, offsetBy: s_utf8.count) // GOOD
    let _ = s_utf8.index(s_utf8.startIndex, offsetBy: s.count) // BAD [NOT DETECTED]

    let s_utf16 = s.utf16
    let _ = s.index(s.startIndex, offsetBy: s_utf16.count) // BAD
    let _ = s_utf16.index(s_utf16.startIndex, offsetBy: scalars.count) // GOOD
    let _ = s_utf16.index(s_utf16.startIndex, offsetBy: s.count) // BAD [NOT DETECTED]

    // --- methods provided by Sequence, Collection etc ---

    let _ = String(s.prefix(s.count - 10)) // GOOD
    let _ = String(s.prefix(s.utf8.count - 10)) // BAD
    let _ = String(s.prefix(s.utf16.count - 10)) // BAD
    let _ = String(s.prefix(s.unicodeScalars.count - 10)) // BAD
    let _ = String(s.prefix(ns.length - 10)) // BAD
    let _ = String(s.prefix(nms.length - 10)) // BAD
    let _ = String(scalars.prefix(s.count - 10)) // BAD
    let _ = String(scalars.prefix(s.utf8.count - 10)) // BAD
    let _ = String(scalars.prefix(s.utf16.count - 10)) // BAD
    let _ = String(scalars.prefix(s.unicodeScalars.count - 10)) // GOOD
    let _ = String(scalars.prefix(ns.length - 10)) // BAD
    let _ = String(scalars.prefix(nms.length - 10)) // BAD
    let _ = String(s.utf8.dropFirst(s.count - 10)) // BAD
    let _ = String(s.utf8.dropFirst(s.utf8.count - 10)) // GOOD
    let _ = String(s.utf16.dropLast(s.count - 10)) // BAD
    let _ = String(s.utf16.dropLast(s.utf16.count - 10)) // GOOD
}

// `begin :thumbsup: end`, with thumbs up emoji and skin tone modifier
test(s: "begin \u{0001F44D}\u{0001F3FF} end")

extension String {
    func newStringMethod() {
        _ = NSMakeRange(0, count) // BAD
        _ = NSMakeRange(0, utf8.count) // BAD
        _ = NSMakeRange(0, utf16.count) // GOOD (`String.UTF16View` and `NSString` lengths are equivalent)
        _ = NSMakeRange(0, unicodeScalars.count) // BAD
    }
}
