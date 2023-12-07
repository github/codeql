
// --- stubs ---

struct AnyRegexOutput {
}

protocol RegexComponent<RegexOutput> {
	associatedtype RegexOutput
}

struct Regex<Output> : RegexComponent {
	struct Match {
	}

	init(_ pattern: String) throws where Output == AnyRegexOutput { }

	func ignoresCase(_ ignoresCase: Bool = true) -> Regex<Regex<Output>.RegexOutput> { return self }

	func firstMatch(in string: String) throws -> Regex<Output>.Match? { return nil }

	typealias RegexOutput = Output
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
		static var caseInsensitive: NSString.CompareOptions { get { return CompareOptions(rawValue: 2) } }
	}
}

// --- tests ---

func tests(input: String) throws {
	_ = try Regex("^a|").firstMatch(in: input)
	_ = try Regex("^a|b").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("a|^b").firstMatch(in: input)
	_ = try Regex("^a|^b").firstMatch(in: input)
	_ = try Regex("^a|b|c").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("a|^b|c").firstMatch(in: input)
	_ = try Regex("a|b|^c").firstMatch(in: input)
	_ = try Regex("^a|^b|c").firstMatch(in: input)

	_ = try Regex("(^a)|b").firstMatch(in: input)
	_ = try Regex("^a|(b)").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("^a|(^b)").firstMatch(in: input)
	_ = try Regex("^(a)|(b)").firstMatch(in: input) // BAD (missing anchor)

	_ = try Regex("a|b$").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("a$|b").firstMatch(in: input)
	_ = try Regex("a$|b$").firstMatch(in: input)
	_ = try Regex("a|b|c$").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("a|b$|c").firstMatch(in: input)
	_ = try Regex("a$|b|c").firstMatch(in: input)
	_ = try Regex("a|b$|c$").firstMatch(in: input)

	_ = try Regex("a|(b$)").firstMatch(in: input)
	_ = try Regex("(a)|b$").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("(a$)|b$").firstMatch(in: input)
	_ = try Regex("(a)|(b)$").firstMatch(in: input) // BAD (missing anchor)

	_ = try Regex(#"^good.com|better.com"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^good\.com|better\.com"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^good\\.com|better\\.com"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^good\\\.com|better\\\.com"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^good\\\\.com|better\\\\.com"#).firstMatch(in: input) // BAD (missing anchor)

	_ = try Regex("^foo|bar|baz$").firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex("^foo|%").firstMatch(in: input)
}

func realWorld(input: String) throws {
	// real-world examples that have been anonymized a bit
	// the following are bad:
	_ = try Regex(#"(\.xxx)|(\.yyy)|(\.zzz)$"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"(^left|right|center)\sbottom$"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"\.xxx|\.yyy|\.zzz$"#).ignoresCase().firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"\.xxx|\.yyy|\.zzz$"#).ignoresCase().firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"\.xxx|\.yyy|zzz$"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^([A-Z]|xxx[XY]$)"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^(xxx yyy zzz)|(xxx yyy)"#).ignoresCase().firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^(xxx yyy zzz)|(xxx yyy)|(1st( xxx)? yyy)|xxx|1st"#).ignoresCase().firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^(xxx:)|(yyy:)|(zzz:)"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^(xxx?:)|(yyy:zzz\/)"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^@media|@page"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^\s*(xxx?|yyy|zzz):|xxx:yyy"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^click|mouse|touch"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^http://good\.com|http://better\.com"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^https?://good\.com|https?://better\.com"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^mouse|touch|click|contextmenu|drop|dragover|dragend"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"^xxx:|yyy:"#).ignoresCase().firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"_xxx|_yyy|_zzz$"#).firstMatch(in: input) // BAD (missing anchor)
	_ = try Regex(#"em|%$"#).firstMatch(in: input) // BAD (missing anchor) [NOT DETECTED] - not flagged at the moment due to the anchor not being for letters

	// the following are MAYBE OK due to apparent complexity; not flagged
	_ = try Regex(#"(?:^[#?]?|&)([^=&]+)(?:=([^&]*))?"#).firstMatch(in: input)
	_ = try Regex(#"(?m)(^\s*|;\s*)\*.*;"#).firstMatch(in: input)
	_ = try Regex(#"(?m)(^\s*|\[)(?:xxx|yyy_(?:xxx|yyy)|xxx|yyy(?:xxx|yyy)?|xxx|yyy)\b"#).firstMatch(in: input)
	_ = try Regex(#"\s\S| \t|\t |\s$"#).firstMatch(in: input)
	_ = try Regex(#"\{[^}{]*\{|\}[^}{]*\}|\{[^}]*$"#).firstMatch(in: input)
	_ = try Regex(#"^((\+|\-)\s*\d\d\d\d)|((\+|\-)\d\d\:?\d\d)"#).firstMatch(in: input)
	_ = try Regex(#"^(\/\/)|([a-z]+:(\/\/)?)"#).firstMatch(in: input)
	_ = try Regex(#"^[=?!#%@$]|!(?=[:}])"#).firstMatch(in: input)
	_ = try Regex(#"^[\[\]!:]|[<>]"#).firstMatch(in: input)
	_ = try Regex(#"^for\b|\b(?:xxx|yyy)\b/"#).ignoresCase().firstMatch(in: input)
	_ = try Regex(#"^if\b|\b(?:xxx|yyy|zzz)\b/"#).ignoresCase().firstMatch(in: input)

	// the following are OK:
	_ = try Regex(#"$^|only-match"#).firstMatch(in: input)
	_ = try Regex(#"(#.+)|#$"#).firstMatch(in: input)
	_ = try Regex(#"(NaN| {2}|^$)"#).firstMatch(in: input)
	_ = try Regex(#"[^\n]*(?:\n|[^\n]$)"#).firstMatch(in: input)
	_ = try Regex(#"^$|\/(?:xxx|yyy)zzz"#).ignoresCase().firstMatch(in: input)
	_ = try Regex(#"^(\/|(xxx|yyy|zzz)$)"#).firstMatch(in: input)
	_ = try Regex(#"^9$|27"#).firstMatch(in: input)
	_ = try Regex(#"^\+|\s*"#).firstMatch(in: input)
	_ = try Regex(#"xxx_yyy=\w+|^$"#).firstMatch(in: input)
	_ = try Regex(#"^(?:mouse|contextmenu)|click"#).firstMatch(in: input)
}

func replaceTest(x: String) -> String {
	// OK - possibly replacing too much, but not obviously a problem
	return x.replacingOccurrences(of: #"^a|b/"#, with: "", options: .regularExpression)
}
