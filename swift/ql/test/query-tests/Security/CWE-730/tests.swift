
// --- stubs ---

struct URL {
    init?(string: String) {}
}

struct AnyRegexOutput {
}

protocol RegexComponent<RegexOutput> {
	associatedtype RegexOutput
}

struct Regex<Output> : RegexComponent {
	struct Match {
	}

	init(_ pattern: String) throws where Output == AnyRegexOutput { }

	func firstMatch(in string: String) throws -> Regex<Output>.Match? { return nil}

	typealias RegexOutput = Output
}

extension RangeReplaceableCollection {
	mutating func replace<Replacement>(_ regex: some RegexComponent, with replacement: Replacement, maxReplacements: Int = .max) where Replacement : Collection, Replacement.Element == Character { }
}

extension StringProtocol {
	func replacingOccurrences<Target, Replacement>(of target: Target, with replacement: Replacement, options: String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil) -> String where Target : StringProtocol, Replacement : StringProtocol { return "" }
}

extension String : RegexComponent {
	typealias CompareOptions = NSString.CompareOptions
	typealias Output = Substring
	typealias RegexOutput = String.Output
}

class NSObject {
}

class NSString : NSObject {
	struct CompareOptions : OptionSet {
	    var rawValue: UInt

		static var regularExpression: NSString.CompareOptions { get { return CompareOptions(rawValue: 1) } }
	}

	convenience init(string aString: String) { self.init() }

	func replacingOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions = [], range searchRange: NSRange) -> String { return "" }

	var length: Int { get { return 0 } }
}

struct _NSRange {
	init(location: Int, length: Int) { }
}

typealias NSRange = _NSRange

func NSMakeRange(_ loc: Int, _ len: Int) -> NSRange { return NSRange(location: loc, length: len) }

class NSTextCheckingResult : NSObject {
}

class NSRegularExpression : NSObject {
	struct Options : OptionSet {
	    var rawValue: UInt
	}

	struct MatchingOptions : OptionSet {
	    var rawValue: UInt
	}

	init(pattern: String, options: NSRegularExpression.Options = []) throws { }

	func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> NSTextCheckingResult? { return nil }

    class func escapedPattern(for string: String) -> String { return "" }
}

extension String {
    init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
}

// --- tests ---

func regexInjectionTests(cond: Bool, varString: String, myUrl: URL) throws {
	let constString = ".*"
	let taintedString = String(contentsOf: myUrl) // tainted

	// --- Regex ---

	_ = try Regex(constString).firstMatch(in: varString)
	_ = try Regex(varString).firstMatch(in: varString)
	_ = try Regex(taintedString).firstMatch(in: varString) // BAD

	_ = try Regex("(a|" + constString + ")").firstMatch(in: varString)
	_ = try Regex("(a|" + taintedString + ")").firstMatch(in: varString) // BAD
	_ = try Regex("(a|\(constString))").firstMatch(in: varString)
	_ = try Regex("(a|\(taintedString))").firstMatch(in: varString) // BAD

	_ = try Regex(cond ? constString : constString).firstMatch(in: varString)
	_ = try Regex(cond ? taintedString : constString).firstMatch(in: varString) // BAD
	_ = try Regex(cond ? constString : taintedString).firstMatch(in: varString) // BAD

	_ = try (cond ? Regex(constString) : Regex(constString)).firstMatch(in: varString)
	_ = try (cond ? Regex(taintedString) : Regex(constString)).firstMatch(in: varString) // BAD
	_ = try (cond ? Regex(constString) : Regex(taintedString)).firstMatch(in: varString) // BAD

	// --- RangeReplaceableCollection ---

	var inputVar = varString
	inputVar.replace(constString, with: "")
	inputVar.replace(taintedString, with: "") // BAD
	inputVar.replace(constString, with: taintedString)

	// --- StringProtocol ---

	_ = inputVar.replacingOccurrences(of: constString, with: "", options: .regularExpression)
	_ = inputVar.replacingOccurrences(of: taintedString, with: "", options: .regularExpression) // BAD

	// --- NSRegularExpression ---

	_ = try NSRegularExpression(pattern: constString).firstMatch(in: varString, range: NSMakeRange(0, varString.utf16.count))
	_ = try NSRegularExpression(pattern: taintedString).firstMatch(in: varString, range: NSMakeRange(0, varString.utf16.count)) // BAD

	// --- NSString ---

	let nsString = NSString(string: varString)
	_ = nsString.replacingOccurrences(of: constString, with: "", options: .regularExpression, range: NSMakeRange(0, nsString.length))
	_ = nsString.replacingOccurrences(of: taintedString, with: "", options: .regularExpression, range: NSMakeRange(0, nsString.length)) // BAD

	// --- from the qhelp ---

	let remoteInput = taintedString
	let myRegex = ".*"

	_ = try Regex(remoteInput) // BAD

	let regexStr = "abc|\(remoteInput)"
	_ = try NSRegularExpression(pattern: regexStr) // BAD

	_ = try Regex(myRegex)

	let escapedInput = NSRegularExpression.escapedPattern(for: remoteInput)
	let regexStr4 = "abc|\(escapedInput)"
	_ = try NSRegularExpression(pattern: regexStr4)

	// --- barriers ---

	let okInput = "abc"
	let okInputs = ["abc", "def"]
	let okSet: Set = ["abc", "def"]

	if (taintedString == okInput) {
		_ = try Regex(taintedString).firstMatch(in: varString) // GOOD (effectively sanitized by the check) [FALSE POSITIVE]
	} else {
		_ = try Regex(taintedString).firstMatch(in: varString) // BAD
	}
	if (taintedString != okInput) {
		_ = try Regex(taintedString).firstMatch(in: varString) // BAD
	}
	if (varString == okInput) {
		_ = try Regex(taintedString).firstMatch(in: varString) // BAD
	}
	if (okInputs.contains(taintedString)) {
		_ = try Regex(taintedString).firstMatch(in: varString) // GOOD (effectively sanitized by the check) [FALSE POSITIVE]
	}
	if (okInputs.firstIndex(of: taintedString) != nil) {
		_ = try Regex(taintedString).firstMatch(in: varString) // GOOD (effectively sanitized by the check) [FALSE POSITIVE]
	}
	if let index = okInputs.firstIndex(of: taintedString) {
		_ = try Regex(taintedString).firstMatch(in: varString) // GOOD (effectively sanitized by the check) [FALSE POSITIVE]
	}
	if let index = okInputs.index(of: taintedString) {
		_ = try Regex(taintedString).firstMatch(in: varString) // GOOD (effectively sanitized by the check) [FALSE POSITIVE]
	}
	if (okSet.contains(taintedString)) {
		_ = try Regex(taintedString).firstMatch(in: varString) // GOOD (effectively sanitized by the check) [FALSE POSITIVE]
	}

	// --- multiple evaluations ---

	let re = try Regex(taintedString) // BAD
	_ = try re.firstMatch(in: varString) // (we only want to flag one location total)
	_ = try re.firstMatch(in: varString)
}
