
// --- stubs ---

struct URL {
    init?(string: String) {}
}

extension String {
    init(contentsOf: URL) {
        let data = ""
        self.init(data)
    }
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

    func ignoresCase(_ ignoresCase: Bool = true) -> Regex<Regex<Output>.RegexOutput> { return self }
    func dotMatchesNewlines(_ dotMatchesNewlines: Bool = true) -> Regex<Regex<Output>.RegexOutput> { return self }

	func firstMatch(in string: String) throws -> Regex<Output>.Match? { return nil}

	typealias RegexOutput = Output
}

extension String : RegexComponent {
	typealias Output = Substring
	typealias RegexOutput = String.Output
}

class NSObject {
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

		static var caseInsensitive: NSRegularExpression.Options { get { return Options(rawValue: 1) } }
	}

	struct MatchingOptions : OptionSet {
	    var rawValue: UInt
	}

	init(pattern: String, options: NSRegularExpression.Options = []) throws { }

	func matches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [NSTextCheckingResult] { return [] }
	func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> NSTextCheckingResult? { return nil }
}

// --- tests ---

func myRegexpVariantsTests(myUrl: URL) throws {
    let tainted = String(contentsOf: myUrl) // tainted

    // BAD - doesn't match newlines or `</script >`
    let re1 = try Regex(#"<script.*?>.*?<\/script>"#).ignoresCase(true)
    _ = try re1.firstMatch(in: tainted)

    // BAD - doesn't match `</script >`
    let re2 = try Regex(#"<script.*?>.*?<\/script>/is"#).ignoresCase(true)
    _ = try re2.firstMatch(in: tainted)

    // GOOD
    let re3 = try Regex(#"<script.*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re3.firstMatch(in: tainted)

    // GOOD - we don't care regexps that only match comments
    let re4 = try Regex(#"<!--.*-->"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re4.firstMatch(in: tainted)

    // GOOD
    let re5 = try Regex(#"<!--.*--!?>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re5.firstMatch(in: tainted)

    // BAD, does not match newlines
    let re6 = try Regex(#"<!--.*--!?>"#).ignoresCase(true)
    _ = try re6.firstMatch(in: tainted)

    // BAD - doesn't match inside the script tag
    let re7 = try Regex(#"<script.*?>(.|\s)*?<\/script[^>]*>"#).ignoresCase(true)
    _ = try re7.firstMatch(in: tainted)

    // BAD - doesn't match newlines inside the content
    let re8 = try Regex(#"<script[^>]*?>.*?<\/script[^>]*>"#).ignoresCase(true)
    _ = try re8.firstMatch(in: tainted)

    // BAD - does not match single quotes for attribute values
    let re9 = try Regex(#"<script(\s|\w|=|")*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re9.firstMatch(in: tainted)

    // BAD - does not match double quotes for attribute values
    let re10 = try Regex(#"<script(\s|\w|=|')*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re10.firstMatch(in: tainted)

    // BAD - does not match tabs between attributes
    let re11 = try Regex(#"<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re11.firstMatch(in: tainted)

    // BAD - does not match uppercase SCRIPT tags
    let re12 = try Regex(#"<script.*?>.*?<\/script[^>]*>"#).dotMatchesNewlines(true)
    _ = try re12.firstMatch(in: tainted)

    // BAD - does not match mixed case script tags
    let re13 = try Regex(#"<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>"#).dotMatchesNewlines(true)
    _ = try re13.firstMatch(in: tainted)

    // BAD - doesn't match newlines in the end tag
    let re14 = try Regex(#"<script[^>]*?>[\s\S]*?<\/script.*>"#).ignoresCase(true)
    _ = try re14.firstMatch(in: tainted)

    // GOOD
    let re15 = try Regex(#"<script[^>]*?>[\s\S]*?<\/script[^>]*?>"#).ignoresCase(true)
    _ = try re15.firstMatch(in: tainted)

    // BAD - doesn't match comments with the right capture groups
    let re16 = try Regex(#"<(?:!--([\S|\s]*?)-->)|([^\/\s>]+)[\S\s]*?>"#)
    _ = try re16.firstMatch(in: tainted)

    // BAD - capture groups
    let re17 = try Regex(#"<(?:(?:\/([^>]+)>)|(?:!--([\S|\s]*?)-->)|(?:([^\/\s>]+)((?:\s+[\w\-:.]+(?:\s*=\s*?(?:(?:"[^"]*")|(?:'[^']*')|[^\s"'\/>]+))?)*)[\S\s]*?(\/?)>))"#)
    _ = try re17.firstMatch(in: tainted)

    // BAD - too strict matching on the end tag
    let ns1 = try NSRegularExpression(pattern: #"<script\b[^>]*>([\s\S]*?)<\/script>"#, options: .caseInsensitive)
    _ = ns1.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let ns2 = try NSRegularExpression(pattern: #"(<[a-z\/!$]("[^"]*"|'[^']*'|[^'">])*>|<!(--.*?--\s*)+>)"#, options: .caseInsensitive)
    _ = ns2.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let ns3 = try NSRegularExpression(pattern: #"<(?:(?:!--([\w\W]*?)-->)|(?:!\[CDATA\[([\w\W]*?)\]\]>)|(?:!DOCTYPE([\w\W]*?)>)|(?:\?([^\s\/<>]+) ?([\w\W]*?)[?/]>)|(?:\/([A-Za-z][A-Za-z0-9\-_\:\.]*)>)|(?:([A-Za-z][A-Za-z0-9\-_\:\.]*)((?:\s+[^"'>]+(?:(?:"[^"]*")|(?:'[^']*')|[^>]*))*|\/|\s+)>))"#)
    _ = ns3.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let ns4 = try NSRegularExpression(pattern: #"<!--([\w\W]*?)-->|<([^>]*?)>"#)
    _ = ns4.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD - it's used with the ignorecase flag
    let ns5 = try NSRegularExpression(pattern: #"<script([^>]*)>([\\S\\s]*?)<\/script([^>]*)>"#, options: .caseInsensitive)
    _ = ns5.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - doesn't match --!>
    let ns6 = try NSRegularExpression(pattern: #"-->"#)
    _ = ns6.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD
    let ns7 = try NSRegularExpression(pattern: #"^>|^->|<!--|-->|--!>|<!-$"#)
    _ = ns7.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))
}
