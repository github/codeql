
// --- stubs ---

struct Locale {
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
	func prefixMatch(in string: String) throws -> Regex<Output>.Match? { return nil}
	func wholeMatch(in string: String) throws -> Regex<Output>.Match? { return nil}

	typealias RegexOutput = Output
}

extension RangeReplaceableCollection {
	mutating func replace<Replacement>(_ regex: some RegexComponent, with replacement: Replacement, maxReplacements: Int = .max) where Replacement : Collection, Replacement.Element == Character { }
	func replacing<Replacement>(_ regex: some RegexComponent, with replacement: Replacement, maxReplacements: Int = .max) -> Self where Replacement: Collection, Replacement.Element == Character { return self }
	mutating func trimPrefix(_ regex: some RegexComponent) { }
}

extension StringProtocol {
	func range<T>(of aString: T, options mask:String.CompareOptions = [], range searchRange: Range<Self.Index>? = nil, locale: Locale? = nil) -> Range<Self.Index>? where T : StringProtocol { return nil }
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

	func range(of searchString: String, options mask: NSString.CompareOptions = []) -> NSRange { return NSRange(location: 0, length: 0) }
	func replacingOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions = [], range searchRange: NSRange) -> String { return "" }

	var length: Int { get { return 0 } }
}

class NSMutableString : NSString {
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

	// some types have been simplified a little here
	func numberOfMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> Int { return 0 }
	func enumerateMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange, using block: (Int, Int, Int) -> Void) { }
	func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [NSTextCheckingResult] { return [] }
	func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> NSTextCheckingResult? { return nil }
	func rangeOfFirstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> NSRange { return NSRange(location: 0, length: 0) }
	func replaceMatches(in string: NSMutableString, options: NSRegularExpression.MatchingOptions = [], range: NSRange, withTemplate templ: String) -> Int { return 0 }
	func stringByReplacingMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange, withTemplate templ: String) -> String { return "" }
}

// --- tests ---

func myRegexpMethodsTests() throws {
	let input = "abcdef"
	let regex = try Regex(".*")

	// --- Regex ---

	_ = try regex.firstMatch(in: input)
	_ = try regex.prefixMatch(in: input)
	_ = try regex.wholeMatch(in: input)

	// --- RangeReeplaceableCollection ---

	var inputVar = input
	inputVar.replace(regex, with: "")Var
	_ = input.replacing(regex, with: "")
	inputVar.trimPrefix(regex)Var

	// --- StringProtocol ---

	_ = input.range(of: ".*", options: .regularExpression, range: nil, locale: nil)
	_ = input.replacingOccurrences(of: ".*", with: "", options: .regularExpression)

	// --- NSRegularExpression ---

	let nsregex = try NSRegularExpression(pattern: ".*")
	_ = nsregex.numberOfMatches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
	nsregex.enumerateMatches(in: input, range: NSMakeRange(0, input.utf16.count), using: {a, b, c in } )
	_ = nsregex.matches(in: input, range: NSMakeRange(0, input.utf16.count))
	_ = nsregex.firstMatch(in: input, range: NSMakeRange(0, input.utf16.count))
	_ = nsregex.rangeOfFirstMatch(in: input, range: NSMakeRange(0, input.utf16.count))
	_ = nsregex.replaceMatches(in: NSMutableString(string: input), range: NSMakeRange(0, input.utf16.count), withTemplate: "")
	_ = nsregex.stringByReplacingMatches(in: input, range: NSMakeRange(0, input.utf16.count), withTemplate: "")

	// --- NSString ---

	let inputNS = NSString(string: "abcdef")
	_ = inputNS.range(of: "*", options: .regularExpression)
	_ = inputNS.replacingOccurrences(of: ".*", with: "", options: .regularExpression, range: NSMakeRange(0, inputNS.length))
}
