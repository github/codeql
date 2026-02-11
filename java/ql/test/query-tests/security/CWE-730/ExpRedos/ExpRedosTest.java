import java.util.regex.Pattern;

class ExpRedosTest {
    static String[] regs = {

        // NOT GOOD; attack: "_" + "__".repeat(100)
        // Adapted from marked (https://github.com/markedjs/marked), which is licensed
        // under the MIT license; see file marked-LICENSE.
        "^\\b_((?:__|[\\s\\S])+?)_\\b|^\\*((?:\\*\\*|[\\s\\S])+?)\\*(?!\\*)", // $ hasExpRedos

        // GOOD
        // Adapted from marked (https://github.com/markedjs/marked), which is licensed
        // under the MIT license; see file marked-LICENSE.
        "^\\b_((?:__|[^_])+?)_\\b|^\\*((?:\\*\\*|[^*])+?)\\*(?!\\*)",

        // GOOD - there is no witness in the end that could cause the regexp to not match
        // Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
        // which is licensed under the MIT license; see file brace-expansion-LICENSE.
        "(.*,)+.+",

        // NOT GOOD; attack: " '" + "\\\\".repeat(100)
        // Adapted from CodeMirror (https://github.com/codemirror/codemirror),
        // which is licensed under the MIT license; see file CodeMirror-LICENSE.
        "^(?:\\s+(?:\"(?:[^\"\\\\]|\\\\\\\\|\\\\.)+\"|'(?:[^'\\\\]|\\\\\\\\|\\\\.)+'|\\((?:[^)\\\\]|\\\\\\\\|\\\\.)+\\)))?", // $ hasExpRedos

        // GOOD
        // Adapted from lulucms2 (https://github.com/yiifans/lulucms2).
        "\\(\\*(?:[\\s\\S]*?\\(\\*[\\s\\S]*?\\*\\))*[\\s\\S]*?\\*\\)",

        // GOOD
        // Adapted from jest (https://github.com/facebook/jest), which is licensed
        // under the MIT license; see file jest-LICENSE.
        "^ *(\\S.*\\|.*)\\n *([-:]+ *\\|[-| :]*)\\n((?:.*\\|.*(?:\\n|$))*)\\n*",

        // NOT GOOD, variant of good3; attack: "a|\n:|\n" + "||\n".repeat(100)
        "^ *(\\S.*\\|.*)\\n *([-:]+ *\\|[-| :]*)\\n((?:.*\\|.*(?:\\n|$))*)a", // $ hasExpRedos

        // NOT GOOD; attack: "/" + "\\/a".repeat(100)
        // Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
        // which is licensed under the Apache License 2.0; see file ANodeBlog-LICENSE.
        "\\/(?![ *])(\\\\\\/|.)*?\\/[gim]*(?=\\W|$)", // $ hasExpRedos

        // NOT GOOD; attack: "##".repeat(100) + "\na"
        // Adapted from CodeMirror (https://github.com/codemirror/codemirror),
        // which is licensed under the MIT license; see file CodeMirror-LICENSE.
        "^([\\s\\[\\{\\(]|#.*)*$", // $ hasExpRedos

        // GOOD
        "(\\r\\n|\\r|\\n)+",

        // BAD - PoC: `node -e "/((?:[^\"\']|\".*?\"|\'.*?\')*?)([(,)]|$)/.test(\"'''''''''''''''''''''''''''''''''''''''''''''\\\"\");"`. It's complicated though, because the regexp still matches something, it just matches the empty-string after the attack string.

        // NOT GOOD; attack: "a" + "[]".repeat(100) + ".b\n"
        // Adapted from Knockout (https://github.com/knockout/knockout), which is
        // licensed under the MIT license; see file knockout-LICENSE
        "^[\\_$a-z][\\_$a-z0-9]*(\\[.*?\\])*(\\.[\\_$a-z][\\_$a-z0-9]*(\\[.*?\\])*)*$", // $ hasExpRedos

        // GOOD
        "(a|.)*",

        // Testing the NFA - only some of the below are detected.
        "^([a-z]+)+$", // $ hasExpRedos
        "^([a-z]*)*$", // $ hasExpRedos
        "^([a-zA-Z0-9])(([\\\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$", // $ hasExpRedos
        "^(([a-z])+.)+[A-Z]([a-z])+$", // $ hasExpRedos

        // NOT GOOD; attack: "[" + "][".repeat(100) + "]!"
        // Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
        // is licensed under the MIT license; see file Prototype.js-LICENSE.
        "(([\\w#:.~>+()\\s-]+|\\*|\\[.*?\\])+)\\s*(,|$)", // $ hasExpRedos

        // NOT GOOD; attack: "'" + "\\a".repeat(100) + '"'
        // Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
        // under the MIT license; see file Prism-LICENSE.
        "(\"|')(\\\\?.)*?\\1", // $ hasExpRedos

        // NOT GOOD
        "(b|a?b)*c", // $ hasExpRedos

        // NOT GOOD
        "(a|aa?)*b", // $ hasExpRedos

        // GOOD
        "(.|\\n)*!",

        // NOT GOOD; attack: "\n".repeat(100) + "."
        "(?s)(.|\\n)*!", // $ hasExpRedos

        // NOT GOOD; attack: "\n".repeat(100) + "."
        "(?is)(.|\\n)*!", // $ hasExpRedos

        // GOOD
        "([\\w.]+)*",

        // NOT GOOD
        "(a|aa?)*b", // $ hasExpRedos

        // NOT GOOD
        "(([\\s\\S]|[^a])*)\"", // $ hasExpRedos

        // GOOD - there is no witness in the end that could cause the regexp to not match
        "([^\"']+)*",

        // NOT GOOD
        "((.|[^a])*)\"", // $ hasExpRedos

        // GOOD
        "((a|[^a])*)\"",

        // NOT GOOD
        "((b|[^a])*)\"", // $ hasExpRedos

        // NOT GOOD
        "((G|[^a])*)\"", // $ hasExpRedos

        // NOT GOOD
        "(([0-9]|[^a])*)\"", // $ hasExpRedos

        // NOT GOOD
        "(?:=(?:([!#\\$%&'\\*\\+\\-\\.\\^_`\\|~0-9A-Za-z]+)|\"((?:\\\\[\\x00-\\x7f]|[^\\x00-\\x08\\x0a-\\x1f\\x7f\"])*)\"))?", // $ MISSING: hasExpRedos

        // NOT GOOD
        "\"((?:\\\\[\\x00-\\x7f]|[^\\x00-\\x08\\x0a-\\x1f\\x7f\"])*)\"", // $ MISSING: hasExpRedos

        // GOOD
        "\"((?:\\\\[\\x00-\\x7f]|[^\\x00-\\x08\\x0a-\\x1f\\x7f\"\\\\])*)\"",

        // NOT GOOD
        "(([a-z]|[d-h])*)\"", // $ hasExpRedos

        // NOT GOOD
        "(([^a-z]|[^0-9])*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\d|[0-9])*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\s|\\s)*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\w|G)*)\"", // $ hasExpRedos

        // GOOD
        "((\\s|\\d)*)\"",

        // NOT GOOD
        "((\\d|\\w)*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\d|5)*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\s|[\\f])*)\"", // $ hasExpRedos

        // NOT GOOD - but not detected (likely because \v is a character class in Java rather than a specific character in other langs)
        "((\\s|[\\v]|\\\\v)*)\"", // $ MISSING: hasExpRedos

        // NOT GOOD
        "((\\f|[\\f])*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\W|\\D)*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\S|\\w)*)\"", // $ hasExpRedos

        // NOT GOOD
        "((\\S|[\\w])*)\"", // $ hasExpRedos

        // NOT GOOD
        "((1s|[\\da-z])*)\"", // $ hasExpRedos

        // NOT GOOD
        "((0|[\\d])*)\"", // $ hasExpRedos

        // NOT GOOD
        "(([\\d]+)*)\"", // $ hasExpRedos

        // GOOD - there is no witness in the end that could cause the regexp to not match
        "(\\d+(X\\d+)?)+",

        // GOOD - there is no witness in the end that could cause the regexp to not match
        "([0-9]+(X[0-9]*)?)*",

        // GOOD
        "^([^>]+)*(>|$)",

        // NOT GOOD
        "^([^>a]+)*(>|$)", // $ hasExpRedos

        // NOT GOOD
        "(\\n\\s*)+$", // $ hasExpRedos

        // NOT GOOD
        "^(?:\\s+|#.*|\\(\\?#[^)]*\\))*(?:[?*+]|\\{\\d+(?:,\\d*)?})", // $ hasExpRedos

        // NOT GOOD
        "\\{\\[\\s*([a-zA-Z]+)\\(([a-zA-Z]+)\\)((\\s*([a-zA-Z]+)\\: ?([ a-zA-Z{}]+),?)+)*\\s*\\]\\}", // $ hasExpRedos

        // NOT GOOD
        "(a+|b+|c+)*c", // $ hasExpRedos

        // NOT GOOD
        "(((a+a?)*)+b+)", // $ hasExpRedos

        // NOT GOOD
        "(a+)+bbbb", // $ hasExpRedos

        // GOOD
        "(a+)+aaaaa*a+",

        // NOT GOOD
        "(a+)+aaaaa$", // $ hasExpRedos

        // GOOD
        "(\\n+)+\\n\\n",

        // NOT GOOD
        "(\\n+)+\\n\\n$", // $ hasExpRedos

        // NOT GOOD
        "([^X]+)*$", // $ hasExpRedos

        // NOT GOOD
        "(([^X]b)+)*$", // $ hasExpRedos

        // GOOD
        "(([^X]b)+)*($|[^X]b)",

        // NOT GOOD
        "(([^X]b)+)*($|[^X]c)", // $ hasExpRedos

        // GOOD
        "((ab)+)*ababab",

        // GOOD
        "((ab)+)*abab(ab)*(ab)+",

        // GOOD
        "((ab)+)*",

        // NOT GOOD
        "((ab)+)*$", // $ hasExpRedos

        // GOOD
        "((ab)+)*[a1][b1][a2][b2][a3][b3]",

        // NOT GOOD
        "([\\n\\s]+)*(.)", // $ hasExpRedos

        // GOOD - any witness passes through the accept state.
        "(A*A*X)*",

        // GOOD
        "([^\\\\\\]]+)*",

        // NOT GOOD
        "(\\w*foobarbaz\\w*foobarbaz\\w*foobarbaz\\w*foobarbaz\\s*foobarbaz\\d*foobarbaz\\w*)+-", // $ hasExpRedos

        // NOT GOOD
        "(.thisisagoddamnlongstringforstresstestingthequery|\\sthisisagoddamnlongstringforstresstestingthequery)*-", // $ hasExpRedos

        // NOT GOOD
        "(thisisagoddamnlongstringforstresstestingthequery|this\\w+query)*-", // $ hasExpRedos

        // GOOD
        "(thisisagoddamnlongstringforstresstestingthequery|imanotherbutunrelatedstringcomparedtotheotherstring)*-",

        // GOOD (but false positive caused by the extractor converting all four unpaired surrogates to \uFFFD)
        "foo([\uDC66\uDC67]|[\uDC68\uDC69])*foo", // $ SPURIOUS: hasExpRedos

        // GOOD (but false positive caused by the extractor converting all four unpaired surrogates to \uFFFD)
        "foo((\uDC66|\uDC67)|(\uDC68|\uDC69))*foo", // $ SPURIOUS: hasExpRedos

        // NOT GOOD (but cannot currently construct a prefix)
        "a{2,3}(b+)+X", // $ hasExpRedos

        // NOT GOOD (and a good prefix test)
        "^<(\\w+)((?:\\s+\\w+(?:\\s*=\\s*(?:(?:\"[^\"]*\")|(?:'[^']*')|[^>\\s]+))?)*)\\s*(\\/?)>", // $ hasExpRedos

        // GOOD
        "(a+)*[\\s\\S][\\s\\S][\\s\\S]?",

        // GOOD - but we fail to see that repeating the attack string ends in the "accept any" state (due to not parsing the range `[\s\S]{2,3}`).
        "(a+)*[\\s\\S]{2,3}", // $ SPURIOUS: hasExpRedos

        // GOOD - but we spuriously conclude that a rejecting suffix exists (due to not parsing the range `[\s\S]{2,}` when constructing the NFA).
        "(a+)*([\\s\\S]{2,}|X)$", // $ SPURIOUS: hasExpRedos

        // GOOD
        "(a+)*([\\s\\S]*|X)$",

        // NOT GOOD
        "((a+)*$|[\\s\\S]+)", // $ hasExpRedos

        // GOOD - but still flagged. The only change compared to the above is the order of alternatives, which we don't model.
        "([\\s\\S]+|(a+)*$)", // $ SPURIOUS: hasExpRedos

        // GOOD
        "((;|^)a+)+$",

        // NOT GOOD (a good prefix test)
        "(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f", // $ hasExpRedos

        // NOT GOOD
        "^ab(c+)+$", // $ hasExpRedos

        // NOT GOOD
        "(\\d(\\s+)*){20}", // $ hasExpRedos

        // GOOD - but we spuriously conclude that a rejecting suffix exists.
        "(([^/]|X)+)(\\/[\\s\\S]*)*$", // $ SPURIOUS: hasExpRedos

        // GOOD - but we spuriously conclude that a rejecting suffix exists.
        "^((x([^Y]+)?)*(Y|$))", // $ SPURIOUS: hasExpRedos

        // NOT GOOD
        "(a*)+b", // $ hasExpRedos

        // NOT GOOD
        "foo([\\w-]*)+bar", // $ hasExpRedos

        // NOT GOOD
        "((ab)*)+c", // $ hasExpRedos

        // NOT GOOD
        "(a?a?)*b", // $ hasExpRedos

        // GOOD
        "(a?)*b",

        // NOT GOOD - but not detected
        "(c?a?)*b", // $ MISSING: hasExpRedos

        // NOT GOOD
        "(?:a|a?)+b", // $ hasExpRedos

        // NOT GOOD - but not detected.
        "(a?b?)*$", // $ MISSING: hasExpRedos

        // NOT GOOD
        "PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)", // $ hasExpRedos

        // NOT GOOD
        "^((a)+\\w)+$", // $ hasExpRedos

        // NOT GOOD
        "^(b+.)+$", // $ hasExpRedos

        // GOOD
        "a*b",

        // All 4 bad combinations of nested * and +
        "(a*)*b", // $ hasExpRedos
        "(a+)*b", // $ hasExpRedos
        "(a*)+b", // $ hasExpRedos
        "(a+)+b", // $ hasExpRedos

        // GOOD
        "(a|b)+",
        "(?:[\\s;,\"'<>(){}|\\[\\]@=+*]|:(?![/\\\\]))+",

        "^((?:a{|-)|\\w\\{)+X$", // $ hasParseFailure
        "^((?:a{0|-)|\\w\\{\\d)+X$", // $ hasParseFailure
        "^((?:a{0,|-)|\\w\\{\\d,)+X$", // $ hasParseFailure
        "^((?:a{0,2|-)|\\w\\{\\d,\\d)+X$", // $ hasParseFailure

        // GOOD
        "^((?:a{0,2}|-)|\\w\\{\\d,\\d\\})+X$",

        // NOT GOOD
        "X(\\u0061|a)*Y", // $ hasExpRedos

        // GOOD
        "X(\\u0061|b)+Y",

        // NOT GOOD
        "X(\\x61|a)*Y", // $ hasExpRedos

        // GOOD
        "X(\\x61|b)+Y",

        // NOT GOOD
        "X(\\x{061}|a)*Y", // $ hasExpRedos

        // GOOD
        "X(\\x{061}|b)+Y",

        // NOT GOOD
        "X(\\p{Digit}|7)*Y", // $ hasExpRedos

        // GOOD
        "X(\\p{Digit}|b)+Y",

         // NOT GOOD
        "X(\\P{Digit}|b)*Y", // $ hasExpRedos

        // GOOD
        "X(\\P{Digit}|7)+Y",

        // NOT GOOD
        "X(\\p{IsDigit}|7)*Y", // $ hasExpRedos

        // GOOD
        "X(\\p{IsDigit}|b)+Y",

         // NOT GOOD - but not detected
        "X(\\p{Alpha}|a)*Y", // $ MISSING: hasExpRedos

        // GOOD
        "X(\\p{Alpha}|7)+Y",

        // GOOD
        "(\"[^\"]*?\"|[^\"\\s]+)+(?=\\s*|\\s*$)",

        // BAD
        "/(\"[^\"]*?\"|[^\"\\s]+)+(?=\\s*|\\s*$)X", // $ hasExpRedos
        "/(\"[^\"]*?\"|[^\"\\s]+)+(?=X)", // $ hasExpRedos

        // BAD
        "\\A(\\d|0)*x", // $ hasExpRedos
        "(\\d|0)*\\Z", // $ hasExpRedos
        "\\b(\\d|0)*x", // $ hasExpRedos

        // GOOD - possessive quantifiers don't backtrack
        "(a*+)*+b",
        "(a*)*+b",
        "(a*+)*b",

        // BAD
        "(a*)*b", // $ hasExpRedos

        // BAD - but not detected due to the way possessive quantifiers are approximated
        "((aa|a*+)b)*c", // $ MISSING: hasExpRedos

        // BAD - testing mode flag groups
        "(?is)(a|aa?)*b" // $ hasExpRedos hasPrefixMsg= hasPump=a
    };

    void test() {
        for (int i = 0; i < regs.length; i++) {
            Pattern.compile(regs[i]);
        }
    }
}
