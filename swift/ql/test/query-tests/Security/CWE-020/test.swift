
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

	func firstMatch(in string: String) throws -> Regex<Output>.Match? { return nil}
	func wholeMatch(in string: String) throws -> Regex<Output>.Match? { return nil }

	typealias RegexOutput = Output
}

extension String : RegexComponent {
	typealias Output = Substring
	typealias RegexOutput = String.Output
}

// --- tests ---

func id(_ s : String) -> String { return s }

struct MyDomain {
	init(_ hostname: String) {
		self.hostname = hostname
	}

	var hostname: String
}

func testHostnames(myUrl: URL) throws {
	let tainted = String(contentsOf: myUrl) // tainted

	_ = try Regex(#"^http://example\.com/"#).firstMatch(in: tainted) // GOOD
	_ = try Regex(#"^http://example.com/"#).firstMatch(in: tainted) // GOOD (only '.' here gives a valid top-level domain)
	_ = try Regex(#"^http://example.com"#).firstMatch(in: tainted) // BAD (missing anchor)
	_ = try Regex(#"^http://test\.example\.com/"#).firstMatch(in: tainted) // GOOD
	_ = try Regex(#"^http://test\.example.com/"#).firstMatch(in: tainted) // GOOD (only '.' here gives a valid top-level domain)
	_ = try Regex(#"^http://test\.example.com"#).firstMatch(in: tainted) // BAD (missing anchor)
	_ = try Regex(#"^http://test.example.com/"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^http://test[.]example[.]com/"#).firstMatch(in: tainted) // GOOD (alternative method of escaping)

	_ = try Regex(#"^http://test.example.net/"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^http://test.(example-a|example-b).com/"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^http://(.+).example.com/"#).firstMatch(in: tainted) // BAD (incomplete hostname x 2)
	_ = try Regex(#"^http://(\.+)\.example.com/"#).firstMatch(in: tainted) // GOOD
	_ = try Regex(#"^http://(?:.+)\.test\.example.com/"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^http://test.example.com/(?:.*)"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^(.+\.(?:example-a|example-b)\.com)/"#).firstMatch(in: tainted) // BAD (missing anchor)
	_ = try Regex(#"^(https?:)?//((service|www).)?example.com(?=$|/)"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^(http|https)://www.example.com/p/f/"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^(http://sub.example.com/)"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^https?://api.example.com/"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^http[s]?://?sub1\.sub2\.example\.com/f/(.+)"#).firstMatch(in: tainted) // GOOD (it has a capture group after the TLD, so should be ignored)
	_ = try Regex(#"^https://[a-z]*.example.com$"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"^(example.dev|example.com)"#).firstMatch(in: tainted) // GOOD (any extended hostname wouldn't be included in the capture group) [FALSE POSITIVE]
	_ = try Regex(#"^protos?://(localhost|.+.example.net|.+.example-a.com|.+.example-b.com|.+.example.internal)"#).firstMatch(in: tainted) // BAD (incomplete hostname x3, missing anchor x 1)

	_ = try Regex(#"^http://(..|...)\.example\.com/index\.html"#).firstMatch(in: tainted) // GOOD (wildcards are intentional)
	_ = try Regex(#"^http://.\.example\.com/index\.html"#).firstMatch(in: tainted) // GOOD (the wildcard is intentional)
	_ = try Regex(#"^(foo.example\.com|whatever)$"#).firstMatch(in: tainted) // DUBIOUS (one disjunction doesn't even look like a hostname) [DETECTED incomplete hostname, missing anchor]

	_ = try Regex(#"^test.example.com$"#).firstMatch(in: tainted) // BAD (incomplete hostname)
	_ = try Regex(#"test.example.com"#).wholeMatch(in: tainted) // BAD (incomplete hostname, missing anchor)

	_ = try Regex(id(id(id(#"test.example.com$"#)))).firstMatch(in: tainted) // BAD (incomplete hostname)

	let hostname = #"test.example.com$"# // BAD (incomplete hostname) [NOT DETECTED]
	_ = try Regex("\(hostname)").firstMatch(in: tainted)

	var domain = MyDomain("")
	domain.hostname = #"test.example.com$"# // BAD (incomplete hostname)
	_ = try Regex(domain.hostname).firstMatch(in: tainted)

	func convert1(_ domain: MyDomain) throws -> Regex<AnyRegexOutput> {
		return try Regex(domain.hostname)
	}
	_ = try convert1(MyDomain(#"test.example.com$"#)).firstMatch(in: tainted) // BAD (incomplete hostname)

	let domains = [ MyDomain(#"test.example.com$"#) ]  // BAD (incomplete hostname) [NOT DETECTED]
	func convert2(_ domain: MyDomain) throws -> Regex<AnyRegexOutput> {
		return try Regex(domain.hostname)
	}
	_ = try domains.map({ try convert2($0).firstMatch(in: tainted) })

	let primary = "example.com$"
	_ = try Regex("test." + primary).firstMatch(in: tainted) // BAD (incomplete hostname) [NOT DETECTED]
	_ = try Regex("test." + "example.com$").firstMatch(in: tainted) // BAD (incomplete hostname) [NOT DETECTED]
	_ = try Regex(#"^http://localhost:8000|" + "^https?://.+\.example\.com/"#).firstMatch(in: tainted) // BAD (incomplete hostname) [NOT DETECTED]
	_ = try Regex(#"^http://localhost:8000|" + "^https?://.+.example\.com/"#).firstMatch(in: tainted) // BAD (incomplete hostname) [NOT DETECTED]

	let harmless = #"^http://test.example.com"# // GOOD (never used as a regex)
}
