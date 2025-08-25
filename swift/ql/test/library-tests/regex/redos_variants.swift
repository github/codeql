
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
    func prefixMatch(in string: String) throws -> Regex<Output>.Match? { return nil}
    func wholeMatch(in string: String) throws -> Regex<Output>.Match? { return nil}

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
    // attack string: "a" x lots + "!"

    _ = try Regex(".*").firstMatch(in: tainted) // $ regex=.* input=tainted

    _ = try Regex("a*b").firstMatch(in: tainted) // $ regex=a*b input=tainted
    _ = try Regex("(a*)b").firstMatch(in: tainted) // $ regex=(a*)b input=tainted
    _ = try Regex("(a)*b").firstMatch(in: tainted) // $ regex=(a)*b input=tainted
    _ = try Regex("(a*)*b").firstMatch(in: tainted) // $ regex=(a*)*b input=tainted redos-vulnerable
    _ = try Regex("((a*)*b)").firstMatch(in: tainted) // $ regex=((a*)*b) input=tainted redos-vulnerable

    _ = try Regex("(a|aa?)b").firstMatch(in: tainted) // $ regex=(a|aa?)b input=tainted
    _ = try Regex("(a|aa?)*b").firstMatch(in: tainted) // $ regex=(a|aa?)*b input=tainted redos-vulnerable

    // from the qhelp:
    // attack string: "_" x lots + "!"

    _ = try Regex("^_(__|.)+_$").firstMatch(in: tainted) // $ regex=^_(__|.)+_$ input=tainted redos-vulnerable
    _ = try Regex("^_(__|[^_])+_$").firstMatch(in: tainted) // $ regex=^_(__|[^_])+_$ input=tainted

    // real world cases:

    // Adapted from marked (https://github.com/markedjs/marked), which is licensed
    // under the MIT license; see file licenses/marked-LICENSE.
    // GOOD
    _ = try Regex(#"^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)"#).firstMatch(in: tainted) // $ regex=^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*) SPURIOUS: redos-vulnerable
    // BAD
    // attack string: "_" + "__".repeat(100)
    _ = try Regex(#"^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)"#).wholeMatch(in: tainted) // $ redos-vulnerable regex=^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)

    // GOOD
    // Adapted from marked (https://github.com/markedjs/marked), which is licensed
    // under the MIT license; see file licenses/marked-LICENSE.
    _ = try Regex(#"^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)"#).firstMatch(in: tainted) // $ regex=^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)

    // GOOD - there is no witness in the end that could cause the regexp to not match
    // Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
    // which is licensed under the MIT license; see file licenses/brace-expansion-LICENSE.
    _ = try Regex("(.*,)+.+").firstMatch(in: tainted) // $ regex=(.*,)+.+

    // BAD
    // attack string: " '" + "\\\\".repeat(100)
    // Adapted from CodeMirror (https://github.com/codemirror/codemirror),
    // which is licensed under the MIT license; see file licenses/CodeMirror-LICENSE.
    _ = try Regex(#"^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?

    // GOOD
    // Adapted from jest (https://github.com/facebook/jest), which is licensed
    // under the MIT license; see file licenses/jest-LICENSE.
    _ = try Regex(#"^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*"#).firstMatch(in: tainted) // $ regex="^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*"

    // BAD
    // attack string: "/" + "\\/a".repeat(100)
    // Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
    // which is licensed under the Apache License 2.0; see file licenses/ANodeBlog-LICENSE.
    _ = try Regex(#"\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)"#).firstMatch(in: tainted) // $ redos-vulnerable regex="\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)"

    // BAD
    // attack string: "##".repeat(100) + "\na"
    // Adapted from CodeMirror (https://github.com/codemirror/codemirror),
    // which is licensed under the MIT license; see file licenses/CodeMirror-LICENSE.
    _ = try Regex(#"^([\s\[\{\(]|#.*)*$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^([\s\[\{\(]|#.*)*$

    // BAD
    // attack string: "a" + "[]".repeat(100) + ".b\n"
    // Adapted from Knockout (https://github.com/knockout/knockout), which is
    // licensed under the MIT license; see file licenses/knockout-LICENSE
    _ = try Regex(#"^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$

    // BAD
    // attack string: "[" + "][".repeat(100) + "]!"
    // Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
    // is licensed under the MIT license; see file licenses/Prototype.js-LICENSE.
    _ = try Regex(#"(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)"#).firstMatch(in: tainted) // $ redos-vulnerable regex=(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)

    // BAD
    // attack string: "'" + "\\a".repeat(100) + '"'
    // Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
    // under the MIT license; see file licenses/Prism-LICENSE.
    _ = try Regex(#"("|')(\\?.)*?\1"#).firstMatch(in: tainted) // $ redos-vulnerable regex=("|')(\\?.)*?\1

    // more cases:

    // GOOD
    _ = try Regex(#"(\r\n|\r|\n)+"#).firstMatch(in: tainted) // $ regex=(\r\n|\r|\n)+

    // GOOD
    _ = try Regex("(a|.)*").firstMatch(in: tainted) // $ regex=(a|.)*

    // BAD - testing the NFA
    // attack string: "a" x lots + "!"
    _ = try Regex("^([a-z]+)+$").firstMatch(in: tainted) // $ redos-vulnerable regex=^([a-z]+)+$
    _ = try Regex("^([a-z]*)*$").firstMatch(in: tainted) // $ redos-vulnerable regex=^([a-z]*)*$
    _ = try Regex(#"^([a-zA-Z0-9])(([\\.-]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^([a-zA-Z0-9])(([\\.-]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$
    _ = try Regex("^(([a-z])+.)+[A-Z]([a-z])+$").firstMatch(in: tainted) // $ redos-vulnerable regex=^(([a-z])+.)+[A-Z]([a-z])+$

    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex("(b|a?b)*c").firstMatch(in: tainted) // $ redos-vulnerable regex=(b|a?b)*c

    // GOOD
    _ = try Regex(#"(.|\n)*!"#).firstMatch(in: tainted) // $ regex=(.|\n)*!

    // BAD
    // attack string: "\n".repeat(100) + "."
    _ = try Regex(#"(?s)(.|\n)*!"#).firstMatch(in: tainted) // $ modes=DOTALL redos-vulnerable regex=(?s)(.|\n)*!

    // GOOD
    _ = try Regex(#"([\w.]+)*"#).firstMatch(in: tainted) // $ regex=([\w.]+)*
    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex(#"([\w.]+)*"#).wholeMatch(in: tainted) // $ regex=([\w.]+)* MISSING: redos-vulnerable

    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex(#"(([\s\S]|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=(([\s\S]|[^a])*)"

    // GOOD - there is no witness in the end that could cause the regexp to not match
    _ = try Regex(#"([^"']+)*"#).firstMatch(in: tainted) // $ regex=([^"']+)*

    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex(#"((.|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((.|[^a])*)"

    // GOOD
    _ = try Regex(#"((a|[^a])*)""#).firstMatch(in: tainted) // $ regex=((a|[^a])*)"

    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex(#"((b|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((b|[^a])*)"

    // BAD
    // attack string: "G" x lots + "!"
    _ = try Regex(#"((G|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((G|[^a])*)"

    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"(([0-9]|[^a])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=(([0-9]|[^a])*)"

    // BAD [NOT DETECTED]
    // (no confirmed attack string)
    _ = try Regex(#"(?:=(?:([!#\$%&'\*\+\-\.\^_`\|~0-9A-Za-z]+)|"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"))?"#).firstMatch(in: tainted) // $ regex=(?:=(?:([!#\$%&'\*\+\-\.\^_`\|~0-9A-Za-z]+)|"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"))? MISSING: redos-vulnerable

    // BAD [NOT DETECTED]
    // (no confirmed attack string)
    _ = try Regex(#""((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)""#).firstMatch(in: tainted) // $ regex="((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)" MISSING: redos-vulnerable

    // GOOD
    _ = try Regex(#""((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"\\])*)""#).firstMatch(in: tainted) // $ regex="((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"\\])*)"

    // BAD
    // attack string: "d" x lots + "!"
    _ = try Regex(#"(([a-z]|[d-h])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=(([a-z]|[d-h])*)"

    // BAD
    // attack string: "_" x lots
    _ = try Regex(#"(([^a-z]|[^0-9])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=(([^a-z]|[^0-9])*)"

    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"((\d|[0-9])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\d|[0-9])*)"

    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"((\s|\s)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\s|\s)*)"

    // BAD
    // attack string: "G" x lots + "!"
    _ = try Regex(#"((\w|G)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\w|G)*)"

    // GOOD
    _ = try Regex(#"((\s|\d)*)""#).firstMatch(in: tainted) // $ regex=((\s|\d)*)"

    // BAD
    // attack string: "5" x lots + "!"
    _ = try Regex(#"((\d|\d)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\d|\d)*)"

    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"((\d|\w)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\d|\w)*)"

    // BAD
    // attack string: "5" x lots + "!"
    _ = try Regex(#"((\d|5)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\d|5)*)"

    // BAD
    // attack string: "\u{000C}" x lots + "!",
    _ = try Regex(#"((\s|[\f])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\s|[\f])*)"

    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"((\s|[\v]|\\v)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\s|[\v]|\\v)*)"

    // BAD
    // attack string: "\u{000C}" x lots + "!",
    _ = try Regex(#"((\f|[\f])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\f|[\f])*)"

    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"((\W|\D)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\W|\D)*)"

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex(#"((\S|\w)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\S|\w)*)"

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex(#"((\S|[\w])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((\S|[\w])*)"

    // BAD
    // attack string: "1s" x lots + "!"
    _ = try Regex(#"((1s|[\da-z])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((1s|[\da-z])*)"

    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"((0|[\d])*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=((0|[\d])*)"

    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"(([\d]+)*)""#).firstMatch(in: tainted) // $ redos-vulnerable regex=(([\d]+)*)"

    // GOOD - there is no witness in the end that could cause the regexp to not match
    _ = try Regex(#"(\d+(X\d+)?)+"#).firstMatch(in: tainted) // $ regex=(\d+(X\d+)?)+
    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"(\d+(X\d+)?)+"#).wholeMatch(in: tainted) // $ regex=(\d+(X\d+)?)+ MISSING: redos-vulnerable

    // GOOD - there is no witness in the end that could cause the regexp to not match
    _ = try Regex("([0-9]+(X[0-9]*)?)*").firstMatch(in: tainted) // $ regex=([0-9]+(X[0-9]*)?)*
    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex("([0-9]+(X[0-9]*)?)*").wholeMatch(in: tainted) // $ regex=([0-9]+(X[0-9]*)?)* MISSING: redos-vulnerable

    // GOOD
    _ = try Regex("^([^>]+)*(>|$)").firstMatch(in: tainted) // $ regex=^([^>]+)*(>|$)

    // BAD
    // attack string: "##".repeat(100) + "\na"
    _ = try Regex("^([^>a]+)*(>|$)").firstMatch(in: tainted) // $ redos-vulnerable regex=^([^>a]+)*(>|$)

    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"(\n\s*)+$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=(\n\s*)+$

    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"^(?:\s+|#.*|\(\?#[^)]*\))*(?:[?*+]|\{\d+(?:,\d*)?})"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^(?:\s+|#.*|\(\?#[^)]*\))*(?:[?*+]|\{\d+(?:,\d*)?})

    // BAD
    // (no confirmed attack string)
    _ = try Regex(#"\{\[\s*([a-zA-Z]+)\(([a-zA-Z]+)\)((\s*([a-zA-Z]+)\: ?([ a-zA-Z{}]+),?)+)*\s*\]\}"#).firstMatch(in: tainted) // $ redos-vulnerable regex="\{\[\s*([a-zA-Z]+)\(([a-zA-Z]+)\)((\s*([a-zA-Z]+)\: ?([ a-zA-Z{}]+),?)+)*\s*\]\}"

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(a+|b+|c+)*c").firstMatch(in: tainted) // $ redos-vulnerable regex=(a+|b+|c+)*c

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(((a+a?)*)+b+)").firstMatch(in: tainted) // $ redos-vulnerable regex=(((a+a?)*)+b+)

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(a+)+bbbb").firstMatch(in: tainted) // $ redos-vulnerable regex=(a+)+bbbb

    // GOOD
    _ = try Regex("(a+)+aaaaa*a+").firstMatch(in: tainted) // $ regex=(a+)+aaaaa*a+
    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(a+)+aaaaa*a+").wholeMatch(in: tainted) // $ regex=(a+)+aaaaa*a+ MISSING: redos-vulnerable

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(a+)+aaaaa$").firstMatch(in: tainted) // $ redos-vulnerable regex=(a+)+aaaaa$

    // GOOD
    _ = try Regex(#"(\n+)+\n\n"#).firstMatch(in: tainted) // $ regex=(\n+)+\n\n
    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"(\n+)+\n\n"#).wholeMatch(in: tainted) // $ regex=(\n+)+\n\n MISSING: redos-vulnerable

    // BAD
    // attack string: "\n" x lots + "."
    _ = try Regex(#"(\n+)+\n\n$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=(\n+)+\n\n$

    // BAD
    // attack string: " " x lots + "X"
    _ = try Regex("([^X]+)*$").firstMatch(in: tainted) // $ redos-vulnerable regex=([^X]+)*$

    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex("(([^X]b)+)*$").firstMatch(in: tainted) // $ redos-vulnerable regex=(([^X]b)+)*$

    // GOOD
    _ = try Regex("(([^X]b)+)*($|[^X]b)").firstMatch(in: tainted) // $ regex=(([^X]b)+)*($|[^X]b)
    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex("(([^X]b)+)*($|[^X]b)").wholeMatch(in: tainted) // $ regex=(([^X]b)+)*($|[^X]b) MISSING: redos-vulnerable

    // BAD
    // attack string: "b" x lots + "!"
    _ = try Regex("(([^X]b)+)*($|[^X]c)").firstMatch(in: tainted) // $ redos-vulnerable regex=(([^X]b)+)*($|[^X]c)

    // GOOD
    _ = try Regex("((ab)+)*ababab").firstMatch(in: tainted) // $ regex=((ab)+)*ababab
    // BAD
    // attack string: "ab" x lots + "!"
    _ = try Regex("((ab)+)*ababab").wholeMatch(in: tainted) // $ regex=((ab)+)*ababab MISSING: redos-vulnerable

    // GOOD
    _ = try Regex("((ab)+)*abab(ab)*(ab)+").firstMatch(in: tainted) // $ regex=((ab)+)*abab(ab)*(ab)+
    // BAD
    // attack string: "ab" x lots + "!"
    _ = try Regex("((ab)+)*abab(ab)*(ab)+").wholeMatch(in: tainted) // $ regex=((ab)+)*abab(ab)*(ab)+ MISSING: redos-vulnerable

    // GOOD
    _ = try Regex("((ab)+)*").firstMatch(in: tainted) // $ regex=((ab)+)*
    // BAD
    // attack string: "ab" x lots + "!"
    _ = try Regex("((ab)+)*").wholeMatch(in: tainted) // $ regex=((ab)+)* MISSING: redos-vulnerable

    // BAD
    // attack string: "ab" x lots + "!"
    _ = try Regex("((ab)+)*$").firstMatch(in: tainted) // $ redos-vulnerable regex=((ab)+)*$

    // GOOD
    _ = try Regex("((ab)+)*[a1][b1][a2][b2][a3][b3]").firstMatch(in: tainted) // $ regex=((ab)+)*[a1][b1][a2][b2][a3][b3]
    // BAD
    // attack string: "ab" x lots + "!"
    _ = try Regex("((ab)+)*[a1][b1][a2][b2][a3][b3]").wholeMatch(in: tainted) // $ regex=((ab)+)*[a1][b1][a2][b2][a3][b3] MISSING: redos-vulnerable

    // BAD
    // (no confirmed attack string)
    _ = try Regex(#"([\n\s]+)*(.)"#).firstMatch(in: tainted) // $ redos-vulnerable regex=([\n\s]+)*(.)

    // GOOD - any witness passes through the accept state.
    _ = try Regex("(A*A*X)*").firstMatch(in: tainted) // $ regex=(A*A*X)*

    // GOOD
    _ = try Regex(#"([^\\\]]+)*"#).firstMatch(in: tainted) // $ regex=([^\\\]]+)*

    // BAD
    _ = try Regex(#"(\w*foobarbaz\w*foobarbaz\w*foobarbaz\w*foobarbaz\s*foobarbaz\d*foobarbaz\w*)+-"#).firstMatch(in: tainted) // $ redos-vulnerable regex=(\w*foobarbaz\w*foobarbaz\w*foobarbaz\w*foobarbaz\s*foobarbaz\d*foobarbaz\w*)+-

    // GOOD
    // (these regexs explore a query performance issue we had at one point)
    _ = try Regex(#"(\w*foobarfoobarfoobarfoobarfoobarfoobarfoobarfoobar)+"#).firstMatch(in: tainted) // $ regex=(\w*foobarfoobarfoobarfoobarfoobarfoobarfoobarfoobar)+
    _ = try Regex(#"(\w*foobarfoobarfoobar)+"#).firstMatch(in: tainted) // $ regex=(\w*foobarfoobarfoobar)+

    // BAD (but cannot currently construct a prefix)
    // attack string: "aa" + "b" x lots + "!"
    _ = try Regex("a{2,3}(b+)+X").firstMatch(in: tainted) // $ redos-vulnerable regex=a{2,3}(b+)+X

    // BAD (and a good prefix test)
    // (no confirmed attack string)
    _ = try Regex(#"^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>

    // GOOD
    _ = try Regex(#"(a+)*[\s\S][\s\S][\s\S]?"#).firstMatch(in: tainted) // $ regex=(a+)*[\s\S][\s\S][\s\S]?

    // GOOD - but we fail to see that repeating the attack string ends in the "accept any" state (due to not parsing the range `[\s\S]{2,3}`).
    _ = try Regex(#"(a+)*[\s\S]{2,3}"#).firstMatch(in: tainted) // $ regex=(a+)*[\s\S]{2,3} SPURIOUS: redos-vulnerable

    // GOOD - but we spuriously conclude that a rejecting suffix exists (due to not parsing the range `[\s\S]{2,}` when constructing the NFA).
    _ = try Regex(#"(a+)*([\s\S]{2,}|X)$"#).firstMatch(in: tainted) // $ regex=(a+)*([\s\S]{2,}|X)$ SPURIOUS: redos-vulnerable

    // GOOD
    _ = try Regex(#"(a+)*([\s\S]*|X)$"#).firstMatch(in: tainted) // $ regex=(a+)*([\s\S]*|X)$

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex(#"((a+)*$|[\s\S]+)"#).firstMatch(in: tainted) // $ redos-vulnerable regex=((a+)*$|[\s\S]+)

    // GOOD - but still flagged. The only change compared to the above is the order of alternatives, which we don't model.
    _ = try Regex(#"([\s\S]+|(a+)*$)"#).firstMatch(in: tainted) // $ regex=([\s\S]+|(a+)*$) SPURIOUS: redos-vulnerable

    // GOOD
    _ = try Regex("((;|^)a+)+$").firstMatch(in: tainted) // $ regex=((;|^)a+)+$

    // BAD (a good prefix test)
    // attack string: "00000000000000" + "e" x lots + "!"
    _ = try Regex("(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f").firstMatch(in: tainted) // $ redos-vulnerable regex=(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f

    // BAD
    // atack string: "ab" + "c" x lots + "!"
     _ = try Regex("^ab(c+)+$").firstMatch(in: tainted) // $ redos-vulnerable regex=^ab(c+)+$

    // BAD
    // (no confirmed attack string)
    _ = try Regex(#"(\d(\s+)*){20}"#).firstMatch(in: tainted) // $ redos-vulnerable regex=(\d(\s+)*){20}

    // GOOD - but we spuriously conclude that a rejecting suffix exists.
    _ = try Regex(#"(([^/]|X)+)(\/[\s\S]*)*$"#).firstMatch(in: tainted) // $ regex=(([^/]|X)+)(\/[\s\S]*)*$ SPURIOUS: redos-vulnerable

    // GOOD - but we spuriously conclude that a rejecting suffix exists.
    _ = try Regex("^((x([^Y]+)?)*(Y|$))").firstMatch(in: tainted) // $ regex=^((x([^Y]+)?)*(Y|$)) SPURIOUS: redos-vulnerable

    // BAD
    // (no confirmed attack string)
    _ = try Regex(#"foo([\w-]*)+bar"#).firstMatch(in: tainted) // $ redos-vulnerable regex=foo([\w-]*)+bar

    // BAD
    // attack string: "ab" x lots + "!"
    _ = try Regex("((ab)*)+c").firstMatch(in: tainted) // $ redos-vulnerable regex=((ab)*)+c

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(a?a?)*b").firstMatch(in: tainted) // $ redos-vulnerable regex=(a?a?)*b

    // GOOD
    _ = try Regex("(a?)*b").firstMatch(in: tainted) // $ regex=(a?)*b

    // BAD - but not detected
    // (no confirmed attack string)
    _ = try Regex("(c?a?)*b").firstMatch(in: tainted) // $ regex=(c?a?)*b MISSING: redos-vulnerable

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex("(?:a|a?)+b").firstMatch(in: tainted) // $ redos-vulnerable regex=(?:a|a?)+b

    // BAD - but not detected.
    // attack string: "ab" x lots + "!"
    _ = try Regex("(a?b?)*$").firstMatch(in: tainted) // $ regex=(a?b?)*$ MISSING: redos-vulnerable

    // BAD
    // (no confirmed attack string)
    _ = try Regex("PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)").firstMatch(in: tainted) // $ redos-vulnerable regex=PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)

    // BAD
    // attack string: "a" x lots + "!"
    _ = try Regex(#"^((a)+\w)+$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^((a)+\w)+$

    // BAD
    // attack string: "bbbbbbbbbb." x lots + "!"
    _ = try Regex("^(b+.)+$").firstMatch(in: tainted) // $ redos-vulnerable regex=^(b+.)+$

    // BAD - all 4 bad combinations of nested * and +
    // attack string: "a" x lots + "!"
    _ = try Regex("(a*)*b").firstMatch(in: tainted) // $ redos-vulnerable regex=(a*)*b
    _ = try Regex("(a+)*b").firstMatch(in: tainted) // $ redos-vulnerable regex=(a+)*b
    _ = try Regex("(a*)+b").firstMatch(in: tainted) // $ redos-vulnerable regex=(a*)+b
    _ = try Regex("(a+)+b").firstMatch(in: tainted) // $ redos-vulnerable regex=(a+)+b

    // GOOD
    _ = try Regex("(a|b)+").firstMatch(in: tainted) // $ regex=(a|b)+

    // GOOD
    _ = try Regex(#"(?:[\s;,"'<>(){}|\[\]@=+*]|:(?![/\\]))+"#).firstMatch(in: tainted) // $ regex=(?:[\s;,"'<>(){}|\[\]@=+*]|:(?![/\\]))+

    // BAD?
    // (no confirmed attack string)
    _ = try Regex(#"^((?:a{|-)|\w\{)+X$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^((?:a{|-)|\w\{)+X$
    _ = try Regex(#"^((?:a{0|-)|\w\{\d)+X$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^((?:a{0|-)|\w\{\d)+X$
    _ = try Regex(#"^((?:a{0,|-)|\w\{\d,)+X$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^((?:a{0,|-)|\w\{\d,)+X$
    _ = try Regex(#"^((?:a{0,2|-)|\w\{\d,\d)+X$"#).firstMatch(in: tainted) // $ redos-vulnerable regex=^((?:a{0,2|-)|\w\{\d,\d)+X$

    // GOOD
    _ = try Regex(#"^((?:a{0,2}|-)|\w\{\d,\d\})+X$"#).firstMatch(in: tainted) // $ regex=^((?:a{0,2}|-)|\w\{\d,\d\})+X$

    // BAD
    // attack string: "X" + "a" x lots
    _ = try Regex(#"X(\u0061|a)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\u0061|a)*Y

    // GOOD
    _ = try Regex(#"X(\u0061|b)+Y"#).firstMatch(in: tainted) // $ regex=X(\u0061|b)+Y

    // BAD
    // attack string: "X" + "a" x lots
    _ = try Regex(#"X(\U00000061|a)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\U00000061|a)*Y

    // GOOD
    _ = try Regex(#"X(\U00000061|b)+Y"#).firstMatch(in: tainted) // $ regex=X(\U00000061|b)+Y

    // BAD
    // attack string: "X" + "a" x lots
    _ = try Regex(#"X(\x61|a)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\x61|a)*Y

    // GOOD
    _ = try Regex(#"X(\x61|b)+Y"#).firstMatch(in: tainted) // $ regex=X(\x61|b)+Y

    // BAD
    // attack string: "X" + "a" x lots
    _ = try Regex(#"X(\x{061}|a)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\x{061}|a)*Y

    // GOOD
    _ = try Regex(#"X(\x{061}|b)+Y"#).firstMatch(in: tainted) // $ regex=X(\x{061}|b)+Y

    // BAD
    // attack string: "X" + "7" x lots
    _ = try Regex(#"X(\p{Digit}|7)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\p{Digit}|7)*Y

    // GOOD
    _ = try Regex(#"X(\p{Digit}|b)+Y"#).firstMatch(in: tainted) // $ regex=X(\p{Digit}|b)+Y

    // BAD
    // attack string: "X" + "b" x lots
    _ = try Regex(#"X(\P{Digit}|b)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\P{Digit}|b)*Y

    // GOOD
    _ = try Regex(#"X(\P{Digit}|7)+Y"#).firstMatch(in: tainted) // $ regex=X(\P{Digit}|7)+Y

    // BAD
    // attack string: "X" + "7" x lots
    _ = try Regex(#"X(\p{IsDigit}|7)*Y"#).firstMatch(in: tainted) // $ redos-vulnerable regex=X(\p{IsDigit}|7)*Y

    // GOOD
    _ = try Regex(#"X(\p{IsDigit}|b)+Y"#).firstMatch(in: tainted) // $ regex=X(\p{IsDigit}|b)+Y

    // BAD - but not detected
    // attack string: "X" + "a" x lots
    _ = try Regex(#"X(\p{Alpha}|a)*Y"#).firstMatch(in: tainted) // $ regex=X(\p{Alpha}|a)*Y MISSING: redos-vulnerable

    // GOOD
    _ = try Regex(#"X(\p{Alpha}|7)+Y"#).firstMatch(in: tainted) // $ regex=X(\p{Alpha}|7)+Y

    // GOOD
    _ = try Regex(#"("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)"#).firstMatch(in: tainted) // $ regex=("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)
    // BAD
    // attack string: "##" x lots + "\na"
    _ = try Regex(#"("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)"#).wholeMatch(in: tainted) // $ regex=("[^"]*?"|[^"\s]+)+(?=\s*|\s*$) MISSING: redos-vulnerable

    // BAD
    // attack string: "/" + "\\/a" x lots
    _ = try Regex(#"/("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)X"#).firstMatch(in: tainted) // $ redos-vulnerable regex=/("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)X
    _ = try Regex(#"/("[^"]*?"|[^"\s]+)+(?=X)"#).firstMatch(in: tainted) // $ redos-vulnerable regex=/("[^"]*?"|[^"\s]+)+(?=X)

    // BAD
    // attack string: "0" x lots + "!"
    _ = try Regex(#"\A(\d|0)*x"#).firstMatch(in: tainted) // $ redos-vulnerable regex=\A(\d|0)*x
    _ = try Regex(#"(\d|0)*\Z"#).firstMatch(in: tainted) // $ redos-vulnerable regex=(\d|0)*\Z
    _ = try Regex(#"\b(\d|0)*x"#).firstMatch(in: tainted) // $ redos-vulnerable regex=\b(\d|0)*x

    // GOOD - possessive quantifiers don't backtrack
    _ = try Regex("(a*+)*+b").firstMatch(in: tainted) // $ hasParseFailure regex=(a*+)*+b
    _ = try Regex("(a*)*+b").firstMatch(in: tainted) // $ hasParseFailure regex=(a*)*+b
    _ = try Regex("(a*+)*b").firstMatch(in: tainted) // $ hasParseFailure regex=(a*+)*b

    // BAD - but not detected due to the way possessive quantifiers are approximated
    // attack string: "aab" x lots + "!"
    _ = try Regex("((aa|a*+)b)*c").firstMatch(in: tainted) // $ hasParseFailure regex=((aa|a*+)b)*c MISSING: redos-vulnerable
}
