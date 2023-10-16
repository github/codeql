
// --- stubs ---

struct URL {
	init?(string: String) {}
}

struct AnyRegexOutput {
}

protocol RegexComponent {
}

struct Regex<Output> : RegexComponent {
	struct Match {
	}

	init(_ pattern: String) throws where Output == AnyRegexOutput { }

	func firstMatch(in string: String) throws -> Regex<Output>.Match? { return nil}

	typealias RegexOutput = Output
}

extension String {
	init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
}

class NSObject {
}

struct _NSRange {
	init(location: Int, length: Int) { }
}

typealias NSRange = _NSRange

class NSRegularExpression : NSObject {
	struct Options : OptionSet {
	    var rawValue: UInt
	}

	struct MatchingOptions : OptionSet {
	    var rawValue: UInt
	}

	init(pattern: String, options: NSRegularExpression.Options = []) throws { }

	func stringByReplacingMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange, withTemplate templ: String) -> String { return "" }
}

// --- tests ---

func myRegexpTests(myUrl: URL) throws {
    let tainted = String(contentsOf: myUrl) // tainted
    let untainted = "abcdef"

    // Regex

    _ = "((a*)*b)" // GOOD (never used)
    _ = try Regex("((a*)*b)") // DUBIOUS (never used) [FLAGGED]
    _ = try Regex("((a*)*b)").firstMatch(in: untainted) // DUBIOUS (never used on tainted input) [FLAGGED]
    _ = try Regex("((a*)*b)").firstMatch(in: tainted) // BAD
    _ = try Regex(".*").firstMatch(in: tainted) // GOOD (safe regex)

    let str = "((a*)*b)" // BAD
    let regex = try Regex(str)
    _ = try regex.firstMatch(in: tainted)

    _ = try Regex(#"(?is)X(?:.|\n)*Y"#) // BAD - suggested attack should begin with 'x' or 'X', *not* 'isx' or 'isX'

    // NSRegularExpression

    _ = try? NSRegularExpression(pattern: "((a*)*b)") // DUBIOUS (never used) [FLAGGED]

    let nsregex1 = try? NSRegularExpression(pattern: "((a*)*b)") // DUBIOUS (never used on tainted input) [FLAGGED]
    _ = nsregex1?.stringByReplacingMatches(in: untainted, range: NSRange(location: 0, length: untainted.utf16.count), withTemplate: "")

    let nsregex2 = try? NSRegularExpression(pattern: "((a*)*b)") // BAD
    _ = nsregex2?.stringByReplacingMatches(in: tainted, range: NSRange(location: 0, length: tainted.utf16.count), withTemplate: "")

    let nsregex3 = try? NSRegularExpression(pattern: ".*") // GOOD (safe regex)
    _ = nsregex3?.stringByReplacingMatches(in: tainted, range: NSRange(location: 0, length: tainted.utf16.count), withTemplate: "")
}
