
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
//
// the focus for these tests is different vulnerable and non-vulnerable regexp strings.

func myRegexpVariantsTests(myUrl: URL) throws {
	let tainted = String(contentsOf: myUrl) // tainted
	let untainted = "abcdef"

	// basic cases:

	_ = try Regex(".*").firstMatch(in: tainted) // $ regex=.* input=tainted

	_ = try Regex("a*b").firstMatch(in: tainted) // $ regex=a*b input=tainted
	_ = try Regex("(a*)b").firstMatch(in: tainted) // $ regex=(a*)b input=tainted
	_ = try Regex("(a)*b").firstMatch(in: tainted) // $ regex=(a)*b input=tainted
	_ = try Regex("(a*)*b").firstMatch(in: tainted) // $ regex=(a*)*b input=tainted redos-vulnerable=
	_ = try Regex("((a*)*b)").firstMatch(in: tainted) // $ regex=((a*)*b) input=tainted redos-vulnerable=

	_ = try Regex("(a|aa?)b").firstMatch(in: tainted) // $ regex=(a|aa?)b input=tainted
	_ = try Regex("(a|aa?)*b").firstMatch(in: tainted) // $ regex=(a|aa?)*b input=tainted redos-vulnerable=

	// from the qhelp:

	_ = try Regex("^_(__|.)+_$").firstMatch(in: tainted) // $ regex=^_(__|.)+_$ input=tainted redos-vulnerable=
	_ = try Regex("^_(__|[^_])+_$").firstMatch(in: tainted) // $ regex=^_(__|[^_])+_$ input=tainted

	// real world cases:

	// NOT GOOD; attack: "_" + "__".repeat(100)
	// Adapted from marked (https://github.com/markedjs/marked), which is licensed
	// under the MIT license; see file licenses/marked-LICENSE.
	_ = try Regex("^\\b_((?:__|[\\s\\S])+?)_\\b|^\\*((?:\\*\\*|[\\s\\S])+?)\\*(?!\\*)").firstMatch(in: tainted) // $ redos-vulnerable=

	// GOOD
	// Adapted from marked (https://github.com/markedjs/marked), which is licensed
	// under the MIT license; see file licenses/marked-LICENSE.
	_ = try Regex("^\\b_((?:__|[^_])+?)_\\b|^\\*((?:\\*\\*|[^*])+?)\\*(?!\\*)").firstMatch(in: tainted)

	// GOOD - there is no witness in the end that could cause the regexp to not match
	// Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
	// which is licensed under the MIT license; see file licenses/brace-expansion-LICENSE.
	_ = try Regex("(.*,)+.+").firstMatch(in: tainted)

	// NOT GOOD; attack: " '" + "\\\\".repeat(100)
	// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
	// which is licensed under the MIT license; see file licenses/CodeMirror-LICENSE.
	_ = try Regex("^(?:\\s+(?:\"(?:[^\"\\\\]|\\\\\\\\|\\\\.)+\"|'(?:[^'\\\\]|\\\\\\\\|\\\\.)+'|\\((?:[^)\\\\]|\\\\\\\\|\\\\.)+\\)))?").firstMatch(in: tainted) // $ redos-vulnerable=

	// GOOD
	// Adapted from jest (https://github.com/facebook/jest), which is licensed
	// under the MIT license; see file licenses/jest-LICENSE.
	_ = try Regex("^ *(\\S.*\\|.*)\\n *([-:]+ *\\|[-| :]*)\\n((?:.*\\|.*(?:\\n|$))*)\\n*").firstMatch(in: tainted)

	// NOT GOOD; attack: "/" + "\\/a".repeat(100)
	// Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
	// which is licensed under the Apache License 2.0; see file licenses/ANodeBlog-LICENSE.
	_ = try Regex("\\/(?![ *])(\\\\\\/|.)*?\\/[gim]*(?=\\W|$)").firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "##".repeat(100) + "\na"
	// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
	// which is licensed under the MIT license; see file licenses/CodeMirror-LICENSE.
	_ = try Regex("^([\\s\\[\\{\\(]|#.*)*$").firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "a" + "[]".repeat(100) + ".b\n"
	// Adapted from Knockout (https://github.com/knockout/knockout), which is
	// licensed under the MIT license; see file licenses/knockout-LICENSE
	_ = try Regex("^[\\_$a-z][\\_$a-z0-9]*(\\[.*?\\])*(\\.[\\_$a-z][\\_$a-z0-9]*(\\[.*?\\])*)*$").firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "[" + "][".repeat(100) + "]!"
	// Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
	// is licensed under the MIT license; see file licenses/Prototype.js-LICENSE.
	_ = try Regex("(([\\w#:.~>+()\\s-]+|\\*|\\[.*?\\])+)\\s*(,|$)").firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "'" + "\\a".repeat(100) + '"'
	// Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
	// under the MIT license; see file licenses/Prism-LICENSE.
	_ = try Regex("(\"|')(\\\\?.)*?\\1").firstMatch(in: tainted) // $ redos-vulnerable=
}
