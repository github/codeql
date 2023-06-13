
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
	_ = try Regex(#"^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// GOOD
	// Adapted from marked (https://github.com/markedjs/marked), which is licensed
	// under the MIT license; see file licenses/marked-LICENSE.
	_ = try Regex(#"^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)"#).firstMatch(in: tainted)

	// GOOD - there is no witness in the end that could cause the regexp to not match
	// Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
	// which is licensed under the MIT license; see file licenses/brace-expansion-LICENSE.
	_ = try Regex("(.*,)+.+").firstMatch(in: tainted)

	// NOT GOOD; attack: " '" + "\\\\".repeat(100)
	// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
	// which is licensed under the MIT license; see file licenses/CodeMirror-LICENSE.
	_ = try Regex(#"^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// GOOD
	// Adapted from jest (https://github.com/facebook/jest), which is licensed
	// under the MIT license; see file licenses/jest-LICENSE.
	_ = try Regex(#"^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*"#).firstMatch(in: tainted)

	// NOT GOOD; attack: "/" + "\\/a".repeat(100)
	// Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
	// which is licensed under the Apache License 2.0; see file licenses/ANodeBlog-LICENSE.
	_ = try Regex(#"\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "##".repeat(100) + "\na"
	// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
	// which is licensed under the MIT license; see file licenses/CodeMirror-LICENSE.
	_ = try Regex(#"^([\s\[\{\(]|#.*)*$"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "a" + "[]".repeat(100) + ".b\n"
	// Adapted from Knockout (https://github.com/knockout/knockout), which is
	// licensed under the MIT license; see file licenses/knockout-LICENSE
	_ = try Regex(#"^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "[" + "][".repeat(100) + "]!"
	// Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
	// is licensed under the MIT license; see file licenses/Prototype.js-LICENSE.
	_ = try Regex(#"(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// NOT GOOD; attack: "'" + "\\a".repeat(100) + '"'
	// Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
	// under the MIT license; see file licenses/Prism-LICENSE.
	_ = try Regex(#"("|')(\\?.)*?\1"#).firstMatch(in: tainted) // $ redos-vulnerable=

	// more cases:

    // GOOD
    _ = try Regex(#"(\r\n|\r|\n)+"#).firstMatch(in: tainted)

    // GOOD
    _ = try Regex("(a|.)*").firstMatch(in: tainted)

    // Testing the NFA - only some of the below are detected.
    _ = try Regex("^([a-z]+)+$").firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex("^([a-z]*)*$").firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex(#"^([a-zA-Z0-9])(([\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$"#).firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex("^(([a-z])+.)+[A-Z]([a-z])+$").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(b|a?b)*c").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(a|aa?)*b").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"(.|\n)*!"#).firstMatch(in: tainted)

    // NOT GOOD; attack: "\n".repeat(100) + "." TODO: investigate, we should be getting this one.
    _ = try Regex(#"(?s)(.|\n)*!"#).firstMatch(in: tainted) // $ hasParseFailure MISSING: redos-vulnerable=

    // GOOD
    _ = try Regex(#"([\w.]+)*"#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex("(a|aa?)*b").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"(([\s\S]|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD - there is no witness in the end that could cause the regexp to not match
    _ = try Regex(#"([^"']+)*"#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"((.|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"((a|[^a])*)""#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"((b|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((G|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"(([0-9]|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD (missing)
    _ = try Regex(#"(?:=(?:([!#\$%&'\*\+\-\.\^_`\|~0-9A-Za-z]+)|"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"))?"#).firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // NOT GOOD (missing)
    _ = try Regex(#""((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)""#).firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // GOOD
    _ = try Regex(#""((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"\\])*)""#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"(([a-z]|[d-h])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"(([^a-z]|[^0-9])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\d|[0-9])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\s|\s)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\w|G)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"((\s|\d)*)""#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"((\d|\w)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\d|5)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\s|[\f])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD - but not detected (likely because \v is a character class in Java rather than a specific character in other langs)
    _ = try Regex(#"((\s|[\v]|\\v)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\f|[\f])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\W|\D)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\S|\w)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((\S|[\w])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((1s|[\da-z])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"((0|[\d])*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"(([\d]+)*)""#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD - there is no witness in the end that could cause the regexp to not match
    _ = try Regex(#"(\d+(X\d+)?)+"#).firstMatch(in: tainted)

    // GOOD - there is no witness in the end that could cause the regexp to not match
    _ = try Regex("([0-9]+(X[0-9]*)?)*").firstMatch(in: tainted)

    // GOOD
    _ = try Regex("^([^>]+)*(>|$)").firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex("^([^>a]+)*(>|$)").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"(\n\s*)+$"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"^(?:\s+|#.*|\(\?#[^)]*\))*(?:[?*+]|\{\d+(?:,\d*)?})"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"\{\[\s*([a-zA-Z]+)\(([a-zA-Z]+)\)((\s*([a-zA-Z]+)\: ?([ a-zA-Z{}]+),?)+)*\s*\]\}"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(a+|b+|c+)*c").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(((a+a?)*)+b+)").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(a+)+bbbb").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("(a+)+aaaaa*a+").firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex("(a+)+aaaaa$").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"(\n+)+\n\n"#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"(\n+)+\n\n$"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("([^X]+)*$").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(([^X]b)+)*$").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("(([^X]b)+)*($|[^X]b)").firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex("(([^X]b)+)*($|[^X]c)").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("((ab)+)*ababab").firstMatch(in: tainted)

    // GOOD
    _ = try Regex("((ab)+)*abab(ab)*(ab)+").firstMatch(in: tainted)

    // GOOD
    _ = try Regex("((ab)+)*").firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex("((ab)+)*$").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("((ab)+)*[a1][b1][a2][b2][a3][b3]").firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"([\n\s]+)*(.)"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD - any witness passes through the accept state.
    _ = try Regex("(A*A*X)*").firstMatch(in: tainted)

    // GOOD
    _ = try Regex(#"([^\\\]]+)*"#).firstMatch(in: tainted)

    // NOT GOOD TODO: QL evaluation times out (for test, at 5 minutes)
//    _ = try Regex(#"(\w*foobarbaz\w*foobarbaz\w*foobarbaz\w*foobarbaz\s*foobarbaz\d*foobarbaz\w*)+-"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD (but cannot currently construct a prefix)
    _ = try Regex("a{2,3}(b+)+X").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD (and a good prefix test)
    _ = try Regex(#"^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"(a+)*[\s\S][\s\S][\s\S]?"#).firstMatch(in: tainted)

    // GOOD - but we fail to see that repeating the attack string ends in the "accept any" state (due to not parsing the range `[\s\S]{2,3}`).
    _ = try Regex(#"(a+)*[\s\S]{2,3}"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=

    // GOOD - but we spuriously conclude that a rejecting suffix exists (due to not parsing the range `[\s\S]{2,}` when constructing the NFA).
    _ = try Regex(#"(a+)*([\s\S]{2,}|X)$"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=

    // GOOD
    _ = try Regex(#"(a+)*([\s\S]*|X)$"#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"((a+)*$|[\s\S]+)"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD - but still flagged. The only change compared to the above is the order of alternatives, which we don't model.
    _ = try Regex(#"([\s\S]+|(a+)*$)"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=

    // GOOD
    _ = try Regex("((;|^)a+)+$").firstMatch(in: tainted)

    // NOT GOOD (a good prefix test)
    _ = try Regex("(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("^ab(c+)+$").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"(\d(\s+)*){20}"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD - but we spuriously conclude that a rejecting suffix exists.
    _ = try Regex(#"(([^/]|X)+)(\/[\s\S]*)*$"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=

    // GOOD - but we spuriously conclude that a rejecting suffix exists.
    _ = try Regex("^((x([^Y]+)?)*(Y|$))").firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(a*)+b").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"foo([\w-]*)+bar"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("((ab)*)+c").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(a?a?)*b").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("(a?)*b").firstMatch(in: tainted)

    // NOT GOOD - but not detected
    _ = try Regex("(c?a?)*b").firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // NOT GOOD
    _ = try Regex("(?:a|a?)+b").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD - but not detected.
    _ = try Regex("(a?b?)*$").firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // NOT GOOD
    _ = try Regex("PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)").firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex(#"^((a)+\w)+$"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // NOT GOOD
    _ = try Regex("^(b+.)+$").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("a*b").firstMatch(in: tainted)

    // All 4 bad combinations of nested * and +
    _ = try Regex("(a*)*b").firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex("(a+)*b").firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex("(a*)+b").firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex("(a+)+b").firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex("(a|b)+").firstMatch(in: tainted)
    _ = try Regex(#"(?:[\s;,"'<>(){}|\[\]@=+*]|:(?![/\\]))+"#).firstMatch(in: tainted)

	// TODO: investigate; these were marked `hasParseFailure`
    _ = try Regex(#"^((?:a{|-)|\w\{)+X$"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=
    _ = try Regex(#"^((?:a{0|-)|\w\{\d)+X$"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=
    _ = try Regex(#"^((?:a{0,|-)|\w\{\d,)+X$"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=
    _ = try Regex(#"^((?:a{0,2|-)|\w\{\d,\d)+X$"#).firstMatch(in: tainted) // $ SPURIOUS: redos-vulnerable=

    // GOOD
    _ = try Regex(#"^((?:a{0,2}|-)|\w\{\d,\d\})+X$"#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"X(\u0061|a)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\u0061|b)+Y"#).firstMatch(in: tainted)

    // NOT GOOD TODO: we should get this one
    _ = try Regex(#"X(\x61|a)*Y"#).firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\x61|b)+Y"#).firstMatch(in: tainted)

    // NOT GOOD TODO: we should get this one
    _ = try Regex(#"X(\x{061}|a)*Y"#).firstMatch(in: tainted) // $ hasParseFailure= MISSING: redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\x{061}|b)+Y"#).firstMatch(in: tainted) // $ hasParseFailure

    // NOT GOOD
    _ = try Regex(#"X(\p{Digit}|7)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\p{Digit}|b)+Y"#).firstMatch(in: tainted)

    // NOT GOOD
    _ = try Regex(#"X(\P{Digit}|b)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\P{Digit}|7)+Y"#).firstMatch(in: tainted)

    // NOT GOOD TODO: we should get this one
    _ = try Regex(#"X(\p{IsDigit}|7)*Y"#).firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\p{IsDigit}|b)+Y"#).firstMatch(in: tainted)

    // NOT GOOD - but not detected
    _ = try Regex(#"X(\p{Alpha}|a)*Y"#).firstMatch(in: tainted) // $ MISSING: redos-vulnerable=

    // GOOD
    _ = try Regex(#"X(\p{Alpha}|7)+Y"#).firstMatch(in: tainted)

    // GOOD
    _ = try Regex(#"("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)"#).firstMatch(in: tainted)

    // BAD
    _ = try Regex(#"/("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)X"#).firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex(#"/("[^"]*?"|[^"\s]+)+(?=X)"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // BAD
    _ = try Regex(#"\A(\d|0)*x"#).firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex(#"(\d|0)*\Z"#).firstMatch(in: tainted) // $ redos-vulnerable=
    _ = try Regex(#"\b(\d|0)*x"#).firstMatch(in: tainted) // $ redos-vulnerable=

    // GOOD - possessive quantifiers don't backtrack
    _ = try Regex("(a*+)*+b").firstMatch(in: tainted) // $ hasParseFailure
    _ = try Regex("(a*)*+b").firstMatch(in: tainted) // $ hasParseFailure
    _ = try Regex("(a*+)*b").firstMatch(in: tainted) // $ hasParseFailure

    // BAD
    _ = try Regex("(a*)*b").firstMatch(in: tainted) // $ redos-vulnerable=

    // BAD - but not detected due to the way possessive quantifiers are approximated
    _ = try Regex("((aa|a*+)b)*c").firstMatch(in: tainted) // $ hasParseFailure MISSING: redos-vulnerable=
}
