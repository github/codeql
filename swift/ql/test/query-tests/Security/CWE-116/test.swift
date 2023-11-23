
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

		static var caseInsensitive: NSRegularExpression.Options { get { return Options(rawValue: 1 << 0) } }
		static var dotMatchesLineSeparators: NSRegularExpression.Options { get { return Options(rawValue: 1 << 1) } }
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
    let re2a = try Regex(#"(?is)<script.*?>.*?<\/script>"#)
    _ = try re2a.firstMatch(in: tainted)
    // BAD - doesn't match `</script >`
    let re2b = try Regex(#"<script.*?>.*?<\/script>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re2b.firstMatch(in: tainted)
    // BAD - doesn't match `</script >`
    let options2c: NSRegularExpression.Options = [.caseInsensitive, .dotMatchesLineSeparators]
    let ns2c = try NSRegularExpression(pattern: #"<script.*?>.*?<\/script>"#, options: options2c)
    _ = ns2c.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD
    let re3a = try Regex(#"(?is)<script.*?>.*?<\/script[^>]*>"#)
    _ = try re3a.firstMatch(in: tainted)
    // GOOD
    let re3b = try Regex(#"<script.*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re3b.firstMatch(in: tainted)
    // GOOD
    let options3b: NSRegularExpression.Options = [.caseInsensitive, .dotMatchesLineSeparators]
    let ns3b = try NSRegularExpression(pattern: #"<script.*?>.*?<\/script[^>]*>"#, options: options3b)
    _ = ns3b.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD - we don't care regexps that only match comments
    let re4 = try Regex(#"<!--.*-->"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re4.firstMatch(in: tainted)

    // GOOD
    let re5 = try Regex(#"<!--.*--!?>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re5.firstMatch(in: tainted)

    // BAD, does not match newlines
    let re6 = try Regex(#"<!--.*--!?>"#).ignoresCase(true)
    _ = try re6.firstMatch(in: tainted)

    // BAD - doesn't match newlines inside the script tag
    let re7 = try Regex(#"<script.*?>(.|\s)*?<\/script[^>]*>"#).ignoresCase(true)
    _ = try re7.firstMatch(in: tainted)

    // BAD - doesn't match newlines inside the content
    let re8 = try Regex(#"<script[^>]*?>.*?<\/script[^>]*>"#).ignoresCase(true)
    _ = try re8.firstMatch(in: tainted)

    // BAD - does not match single quotes for attribute values
    let re9 = try Regex(#"<script(\s|\w|=|")*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re9.firstMatch(in: tainted)

    // BAD - does not match double quotes for attribute values
    let re10a = try Regex(#"(?is)<script(\s|\w|=|')*?>.*?<\/script[^>]*>"#)
    _ = try re10a.firstMatch(in: tainted)
    // BAD - does not match double quotes for attribute values
    let re10b = try Regex(#"<script(\s|\w|=|')*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re10b.firstMatch(in: tainted)
    // BAD - does not match double quotes for attribute values
    let options10: NSRegularExpression.Options = [.caseInsensitive, .dotMatchesLineSeparators]
    let ns10 = try NSRegularExpression(pattern: #"<script(\s|\w|=|')*?>.*?<\/script[^>]*>"#, options: options10)
    _ = ns10.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - does not match tabs between attributes
    let re11a = try Regex(#"(?is)<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>"#)
    _ = try re11a.firstMatch(in: tainted)
    // BAD - does not match tabs between attributes
    let re11b = try Regex(#"<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>"#).ignoresCase(true).dotMatchesNewlines(true)
    _ = try re11b.firstMatch(in: tainted)
    // BAD - does not match tabs between attributes
    let options11: NSRegularExpression.Options = [.caseInsensitive, .dotMatchesLineSeparators]
    let ns11 = try NSRegularExpression(pattern: #"<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>"#, options: options11)
    _ = ns11.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - does not match uppercase SCRIPT tags
    let re12a = try Regex(#"(?s)<script.*?>.*?<\/script[^>]*>"#)
    _ = try re12a.firstMatch(in: tainted)
    // BAD - does not match uppercase SCRIPT tags
    let re12b = try Regex(#"<script.*?>.*?<\/script[^>]*>"#).dotMatchesNewlines(true)
    _ = try re12b.firstMatch(in: tainted)
    // BAD - does not match uppercase SCRIPT tags
    let ns12 = try NSRegularExpression(pattern: #"<script.*?>.*?<\/script[^>]*>"#, options: .dotMatchesLineSeparators)
    _ = ns12.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - does not match mixed case script tags
    let re13a = try Regex(#"(?s)<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>"#)
    _ = try re13a.firstMatch(in: tainted)
    // BAD - does not match mixed case script tags
    let re13b = try Regex(#"<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>"#).dotMatchesNewlines(true)
    _ = try re13b.firstMatch(in: tainted)
    // BAD - does not match mixed case script tags
    let ns13 = try NSRegularExpression(pattern: #"<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>"#, options: .dotMatchesLineSeparators)
    _ = ns13.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - doesn't match newlines in the end tag
    let re14a = try Regex(#"(?i)<script[^>]*?>[\s\S]*?<\/script.*>"#)
    _ = try re14a.firstMatch(in: tainted)
    // BAD - doesn't match newlines in the end tag
    let re14b = try Regex(#"<script[^>]*?>[\s\S]*?<\/script.*>"#).ignoresCase(true)
    _ = try re14b.firstMatch(in: tainted)
    // BAD - doesn't match newlines in the end tag
    let ns14 = try NSRegularExpression(pattern: #"<script[^>]*?>[\s\S]*?<\/script.*>"#, options: .caseInsensitive)
    _ = ns14.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD
    let re15a = try Regex(#"(?i)<script[^>]*?>[\s\S]*?<\/script[^>]*?>"#)
    _ = try re15a.firstMatch(in: tainted)
    // GOOD
    let re15b = try Regex(#"<script[^>]*?>[\s\S]*?<\/script[^>]*?>"#).ignoresCase(true)
    _ = try re15b.firstMatch(in: tainted)
    // GOOD
    let ns15 = try NSRegularExpression(pattern: #"<script[^>]*?>[\s\S]*?<\/script[^>]*?>"#, options: .caseInsensitive)
    _ = ns15.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - doesn't match comments with the right capture groups
    let re16 = try Regex(#"<(?:!--([\S|\s]*?)-->)|([^\/\s>]+)[\S\s]*?>"#)
    _ = try re16.firstMatch(in: tainted)
    // BAD - doesn't match comments with the right capture groups
    let ns16 = try NSRegularExpression(pattern: #"<(?:!--([\S|\s]*?)-->)|([^\/\s>]+)[\S\s]*?>"#)
    _ = ns16.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let re17 = try Regex(#"<(?:(?:\/([^>]+)>)|(?:!--([\S|\s]*?)-->)|(?:([^\/\s>]+)((?:\s+[\w\-:.]+(?:\s*=\s*?(?:(?:"[^"]*")|(?:'[^']*')|[^\s"'\/>]+))?)*)[\S\s]*?(\/?)>))"#)
    _ = try re17.firstMatch(in: tainted)
    // BAD - capture groups
    let ns17 = try NSRegularExpression(pattern: #"<(?:(?:\/([^>]+)>)|(?:!--([\S|\s]*?)-->)|(?:([^\/\s>]+)((?:\s+[\w\-:.]+(?:\s*=\s*?(?:(?:"[^"]*")|(?:'[^']*')|[^\s"'\/>]+))?)*)[\S\s]*?(\/?)>))"#, options: .caseInsensitive)
    _ = ns17.firstMatch(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - too strict matching on the end tag
    let ns2_1 = try NSRegularExpression(pattern: #"<script\b[^>]*>([\s\S]*?)<\/script>"#, options: .caseInsensitive)
    _ = ns2_1.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let ns2_2 = try NSRegularExpression(pattern: #"(<[a-z\/!$]("[^"]*"|'[^']*'|[^'">])*>|<!(--.*?--\s*)+>)"#, options: .caseInsensitive)
    _ = ns2_2.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let ns2_3 = try NSRegularExpression(pattern: #"<(?:(?:!--([\w\W]*?)-->)|(?:!\[CDATA\[([\w\W]*?)\]\]>)|(?:!DOCTYPE([\w\W]*?)>)|(?:\?([^\s\/<>]+) ?([\w\W]*?)[?/]>)|(?:\/([A-Za-z][A-Za-z0-9\-_\:\.]*)>)|(?:([A-Za-z][A-Za-z0-9\-_\:\.]*)((?:\s+[^"'>]+(?:(?:"[^"]*")|(?:'[^']*')|[^>]*))*|\/|\s+)>))"#)
    _ = ns2_3.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - capture groups
    let ns2_4 = try NSRegularExpression(pattern: #"<!--([\w\W]*?)-->|<([^>]*?)>"#)
    _ = ns2_4.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD - it's used with the ignorecase flag
    let ns2_5 = try NSRegularExpression(pattern: #"<script([^>]*)>([\S\s]*?)<\/script([^>]*)>"#, options: .caseInsensitive)
    _ = ns2_5.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // BAD - doesn't match --!>
    let ns2_6 = try NSRegularExpression(pattern: #"-->"#)
    _ = ns2_6.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))

    // GOOD
    let ns2_7 = try NSRegularExpression(pattern: #"^>|^->|<!--|-->|--!>|<!-$"#)
    _ = ns2_7.matches(in: tainted, range: NSMakeRange(0, tainted.utf16.count))
}
