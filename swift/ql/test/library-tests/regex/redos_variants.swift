
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

// --- tests ---

func myRegexpVariantsTests(myUrl: URL) throws {
	let tainted = String(contentsOf: myUrl) // tainted
	let untainted = "abcdef"

	_ = try Regex(".*").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted

	_ = try Regex("a*b").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted
	_ = try Regex("(a*)b").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted
	_ = try Regex("(a)*b").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted
	_ = try Regex("(a*)*b").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted MISSING: redos-vulnerable=
	_ = try Regex("((a*)*b)").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted MISSING: redos-vulnerable=

	_ = try Regex("(a|aa?)b").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted
	_ = try Regex("(a|aa?)*b").firstMatch(in: tainted) // $ regex="call to Regex<AnyRegexOutput>.init(_:)" input=tainted MISSING: redos-vulnerable=

	// TODO: test more variant expressions.
}
