
// --- stubs ---

class NSObject {
}

struct _NSRange {
	init(location: Int, length: Int) { }
}

typealias NSRange = _NSRange

func NSMakeRange(_ loc: Int, _ len: Int) -> NSRange { return NSRange(location: loc, length: len) }

class NSTextCheckingResult : NSObject { }

class NSRegularExpression : NSObject {
	struct Options : OptionSet {
	    var rawValue: UInt

		static var caseInsensitive: NSRegularExpression.Options { get { return Options(rawValue: 1) } }
		static var anchorsMatchLines: NSRegularExpression.Options { get { return Options(rawValue: 2) } }
	}

	struct MatchingOptions : OptionSet {
	    var rawValue: UInt
	}

	init(pattern: String, options: NSRegularExpression.Options = []) throws { }

	func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [NSTextCheckingResult] { return [] }
	func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> NSTextCheckingResult? { return nil }
}

protocol RegexComponent<RegexOutput> {
	associatedtype RegexOutput
}

extension String : RegexComponent {
	typealias CompareOptions = NSString.CompareOptions
	typealias Output = Substring
	typealias RegexOutput = String.Output
}

class NSString : NSObject {
	struct CompareOptions : OptionSet {
	    var rawValue: UInt

		static var regularExpression: NSString.CompareOptions { get { return CompareOptions(rawValue: 1) } }
		static var caseInsensitive: NSString.CompareOptions { get { return CompareOptions(rawValue: 2) } }
	}
}

// --- tests ---

func tests(url: String, secure: Bool) throws {
	let urlRange = NSMakeRange(0, url.utf16.count)

	let input = "http://evil.com/?http://good.com"
	let inputRange = NSMakeRange(0, input.utf16.count)

	_ = try NSRegularExpression(pattern: "https?://good.com").matches(in: input, range: inputRange) // BAD (missing anchor)
	_ = try NSRegularExpression(pattern: "https?://good.com").matches(in: input, range: inputRange) // BAD (missing anchor)
	_ = try NSRegularExpression(pattern: "^https?://good.com").matches(in: input, range: inputRange) // BAD (missing post-anchor)
	_ = try NSRegularExpression(pattern: "(^https?://good1.com)|(^https?://good2.com)").matches(in: input, range: inputRange) // BAD (missing post-anchor)
	_ = try NSRegularExpression(pattern: "(https?://good.com)|(^https?://goodie.com)").matches(in: input, range: inputRange) // BAD (missing anchor)

	_ = try NSRegularExpression(pattern: #"https?:\/\/good.com"#).matches(in: input, range: inputRange) // BAD (missing anchor)
	_ = try NSRegularExpression(pattern: "https?://good.com").matches(in: input, range: inputRange) // BAD (missing anchor)

	if let _ = try NSRegularExpression(pattern: "https?://good.com").firstMatch(in: input, range: inputRange) { } // BAD (missing anchor)

	let input2 = "something"
	let input2Range = NSMakeRange(0, input2.utf16.count)
	_ = try NSRegularExpression(pattern: "other").firstMatch(in: input2, range: input2Range) // OK
	_ = try NSRegularExpression(pattern: "x.commissary").firstMatch(in: input2, range: input2Range) // OK

	_ = try NSRegularExpression(pattern: #"https?://good.com"#).firstMatch(in: input, range: inputRange) // BAD (missing anchor)
	_ = try NSRegularExpression(pattern: #"https?://good.com:8080"#).firstMatch(in: input, range: inputRange) // BAD (missing anchor)

	let trustedUrlRegexs = [
		"https?://good.com", // BAD (missing anchor), referenced below
		#"https?:\/\/good.com"#, // BAD (missing anchor), referenced below
		"^https?://good.com" // BAD (missing post-anchor), referenced below
	]
	for trustedUrlRegex in trustedUrlRegexs {
		if let _ = try NSRegularExpression(pattern: trustedUrlRegex).firstMatch(in: input, range: inputRange) { }
	}

	let trustedUrlRegexs2 = [
		"https?://good.com", // BAD (missing anchor), referenced below
	]
	if let _ = try NSRegularExpression(pattern: trustedUrlRegexs2[0]).firstMatch(in: input, range: inputRange) { }

	let notUsedUrlRegexs = [
		"https?://good.com" // OK (not referenced)
	]
	for _ in notUsedUrlRegexs {
	}

	_ = try NSRegularExpression(pattern: #"https?:\/\/good.com\/([0-9]+)"#).matches(in: url, range: urlRange) // BAD (missing anchor)
	_ = try NSRegularExpression(pattern: "https://verygood.com/?id=" + #"https?:\/\/good.com\/([0-9]+)"#).matches(in: url, range: urlRange)[0] // OK
	_ = try NSRegularExpression(pattern: "http" + (secure ? "s" : "") + "://" + "verygood.com/?id=" + #"https?:\/\/good.com\/([0-9]+)"#).matches(in: url, range: urlRange)[0] // OK
	_ = try NSRegularExpression(pattern: "verygood.com/?id=" + #"https?:\/\/good.com\/([0-9]+)"#).matches(in: url, range: urlRange)[0] // OK

	_ = try NSRegularExpression(pattern: #"\.com|\.org"#).matches(in: input, range: inputRange) // OK, has no domain name
	_ = try NSRegularExpression(pattern: #"example\.com|whatever"#).matches(in: input, range: inputRange) // OK, the other disjunction doesn't match a hostname [FALSE POSITIVE]

	// tests for the `isLineAnchoredHostnameRegExp` case

	let attackUrl1 =  "evil.com/blabla?\ngood.com"
	let attackUrl1Range = NSMakeRange(0, attackUrl1.utf16.count)
	_ = try NSRegularExpression(pattern: "^good\\.com$").matches(in: attackUrl1, range: attackUrl1Range) // OK
	_ = try NSRegularExpression(pattern: "^good\\.com$", options: .anchorsMatchLines).matches(in: attackUrl1, range: attackUrl1Range) // BAD [NOT DETECTED]: with the .anchorsMatchLines option this matches the attack URL
	_ = try NSRegularExpression(pattern: "(?i)^good\\.com$").matches(in: attackUrl1, range: attackUrl1Range) // OK
	_ = try NSRegularExpression(pattern: "(?i)^good\\.com$", options: .anchorsMatchLines).matches(in: attackUrl1, range: attackUrl1Range) // BAD [NOT DETECTED]: with the .anchorsMatchLines option this matches the attack URL
	_ = try NSRegularExpression(pattern: "^good\\.com$|^another\\.com$").matches(in: attackUrl1, range: attackUrl1Range) // OK
	_ = try NSRegularExpression(pattern: "^good\\.com$|^another\\.com$", options: .anchorsMatchLines).matches(in: attackUrl1, range: attackUrl1Range) // BAD [NOT DETECTED]: with the .anchorsMatchLines option this matches the attack URL

	let attackUrl2 =  "evil.com/blabla?\ngood.com/"
	let attackUrl2Range = NSMakeRange(0, attackUrl2.utf16.count)
	_ = try NSRegularExpression(pattern: "^good\\.com/").matches(in: attackUrl2, range: attackUrl2Range) // OK
	_ = try NSRegularExpression(pattern: "^good\\.com/", options: .anchorsMatchLines).matches(in: attackUrl2, range: attackUrl2Range) // BAD [NOT DETECTED]: with the .anchorsMatchLines option this matches the attack URL
	_ = try NSRegularExpression(pattern: "(?i)^good\\.com/").matches(in: attackUrl2, range: attackUrl2Range) // OK
	_ = try NSRegularExpression(pattern: "(?i)^good\\.com/", options: .anchorsMatchLines).matches(in: attackUrl2, range: attackUrl2Range) // BAD [NOT DETECTED]: with the .anchorsMatchLines option this matches the attack URL
	_ = try NSRegularExpression(pattern: "^good\\.com/|^another\\.com/").matches(in: attackUrl2, range: attackUrl2Range) // OK
	_ = try NSRegularExpression(pattern: "^good\\.com/|^another\\.com/", options: .anchorsMatchLines).matches(in: attackUrl2, range: attackUrl2Range) // BAD [NOT DETECTED]: with the .anchorsMatchLines option this matches the attack URL
}
