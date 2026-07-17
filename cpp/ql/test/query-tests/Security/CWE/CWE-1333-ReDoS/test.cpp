// Minimal std::regex/std::basic_string stubs, mirroring the ones in
// cpp/ql/test/library-tests/regex/test.cpp. Real headers are not available
// in the extractor sandbox.

namespace std {

template <class CharT>
class basic_string {
public:
    basic_string() {}
    basic_string(const CharT*) {}
    const CharT* c_str() const { return 0; }
    const CharT* data() const { return 0; }
    unsigned long size() const { return 0; }
};

typedef basic_string<char> string;

namespace regex_constants {
    enum syntax_option_type {
        ECMAScript = 1, basic = 2, extended = 4, awk = 8, grep = 16, egrep = 32,
        icase = 256, nosubs = 512, optimize = 1024, collate = 2048, multiline = 4096
    };
    enum match_flag_type { match_default = 0 };
}

template <class CharT>
class basic_regex {
public:
    typedef regex_constants::syntax_option_type flag_type;
    basic_regex(const CharT* p) {}
    basic_regex(const CharT* p, flag_type f) {}
    basic_regex(const basic_string<CharT>& p) {}
};

typedef basic_regex<char> regex;

template <class CharT>
bool regex_match(const basic_string<CharT>& s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
bool regex_search(const basic_string<CharT>& s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
basic_string<CharT> regex_replace(const basic_string<CharT>& s, const basic_regex<CharT>& re,
                                  const basic_string<CharT>& fmt) { return basic_string<CharT>(); }

} // namespace std

// -----------------------------------------------------------------------------
// Tests for cpp/redos (exponential ReDoS).
//
// Ported from ruby/ql/test/query-tests/security/cwe-1333-exponential-redos/tst.rb.
// Each pattern is constructed as a `std::regex re("...")` and then used in
// `std::regex_match`, which is enough for Phase 1's parser to consider the
// literal a `RegExp`.
//
// Cases are annotated as:
//   BAD  — a cpp/redos alert is expected on the exponential-backtracking term
//   GOOD — no cpp/redos alert is expected
// Any C++-specific divergence from Ruby/JS is noted inline.
// -----------------------------------------------------------------------------

void run(const std::regex& re, const std::string& s) {
    (void)std::regex_match(s, re);
}

int main(int argc, char** argv) {
    std::string input(argv[1]);

    // -------------------------------------------------------------------------
    // 1. Classic nested quantifiers (Ruby bad79..bad82).
    // -------------------------------------------------------------------------

    // BAD: (a*)*b
    { std::regex re("(a*)*b"); run(re, input); }
    // BAD: (a+)*b
    { std::regex re("(a+)*b"); run(re, input); }
    // BAD: (a*)+b
    { std::regex re("(a*)+b"); run(re, input); }
    // BAD: (a+)+b
    { std::regex re("(a+)+b"); run(re, input); }
    // BAD: (a*)+
    { std::regex re("^(a*)+$"); run(re, input); }
    // BAD: ((a+a?)*)+b+  (Ruby bad48)
    { std::regex re("(((a+a?)*)+b+)"); run(re, input); }
    // BAD: (a?a?)*b  (Ruby bad71)
    { std::regex re("(a?a?)*b"); run(re, input); }
    // BAD: (a?)+b via non-capturing alt  (Ruby bad73)
    { std::regex re("(?:a|a?)+b"); run(re, input); }
    // BAD: foo([\w-]*)+bar  (Ruby bad69)
    { std::regex re("foo([\\w-]*)+bar"); run(re, input); }
    // BAD: ((ab)*)+c  (Ruby bad70)
    { std::regex re("((ab)*)+c"); run(re, input); }

    // -------------------------------------------------------------------------
    // 2. Anchored nested-quantifier patterns (Ruby bad7..bad10, bad77, bad78).
    // -------------------------------------------------------------------------

    // BAD: ^([a-z]+)+$
    { std::regex re("^([a-z]+)+$"); run(re, input); }
    // BAD: ^([a-z]*)*$
    { std::regex re("^([a-z]*)*$"); run(re, input); }
    // BAD: e-mail-like regex
    { std::regex re("^([a-zA-Z0-9])(([\\.-]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$");
      run(re, input); }
    // BAD: ^(([a-z])+.)+[A-Z]([a-z])+$
    { std::regex re("^(([a-z])+.)+[A-Z]([a-z])+$"); run(re, input); }
    // BAD: ^((a)+\w)+$
    { std::regex re("^((a)+\\w)+$"); run(re, input); }
    // BAD: ^(b+.)+$
    { std::regex re("^(b+.)+$"); run(re, input); }
    // BAD: ^ab(c+)+$  (Ruby bad66)
    { std::regex re("^ab(c+)+$"); run(re, input); }

    // -------------------------------------------------------------------------
    // 3. Alternations with overlapping / identical branches inside a repetition.
    // -------------------------------------------------------------------------

    // BAD: (a|a)*
    { std::regex re("^(a|a)*$"); run(re, input); }
    // BAD: (a|aa?)*b  (Ruby bad15)
    { std::regex re("(a|aa?)*b"); run(re, input); }
    // BAD: (b|a?b)*c  (Ruby bad13)
    { std::regex re("(b|a?b)*c"); run(re, input); }
    // BAD: (a+|b+|c+)*c  (Ruby bad47)
    { std::regex re("(a+|b+|c+)*c"); run(re, input); }

    // -------------------------------------------------------------------------
    // 4. Character-class / complement ambiguity (Ruby bad52, bad53, bad18,
    //    bad20, bad21, bad22, bad23, bad43).
    // -------------------------------------------------------------------------

    // BAD: ([^X]+)*$
    { std::regex re("([^X]+)*$"); run(re, input); }
    // BAD: (([^X]b)+)*$
    { std::regex re("(([^X]b)+)*$"); run(re, input); }
    // BAD: (([\S\s]|[^a])*)"
    { std::regex re("(([\\S\\s]|[^a])*)\""); run(re, input); }
    // BAD: ((.|[^a])*)"
    { std::regex re("((.|[^a])*)\""); run(re, input); }
    // BAD: ((b|[^a])*)"
    { std::regex re("((b|[^a])*)\""); run(re, input); }
    // BAD: (([0-9]|[^a])*)"
    { std::regex re("(([0-9]|[^a])*)\""); run(re, input); }
    // BAD: ^([^>a]+)*(>|$)
    { std::regex re("^([^>a]+)*(>|$)"); run(re, input); }

    // -------------------------------------------------------------------------
    // 5. Anchored-vs-unanchored GOOD/BAD pairs (Ruby good16/bad50,
    //    good17/bad51, good18/bad54, good20..good22/bad55). These are the
    //    high-value FP-sensitivity cases: an "accept any" tail should make the
    //    otherwise-vulnerable body safe.
    // -------------------------------------------------------------------------

    // GOOD: (a+)+aaaaa*a+     -- Ruby good16 (no rejecting suffix)
    { std::regex re("(a+)+aaaaa*a+"); run(re, input); }
    // BAD:  (a+)+aaaaa$       -- Ruby bad50
    { std::regex re("(a+)+aaaaa$"); run(re, input); }

    // GOOD: (\n+)+\n\n        -- Ruby good17
    { std::regex re("(\\n+)+\\n\\n"); run(re, input); }
    // BAD:  (\n+)+\n\n$       -- Ruby bad51
    { std::regex re("(\\n+)+\\n\\n$"); run(re, input); }

    // GOOD: (([^X]b)+)*($|[^X]b)  -- Ruby good18
    { std::regex re("(([^X]b)+)*($|[^X]b)"); run(re, input); }
    // BAD:  (([^X]b)+)*($|[^X]c)  -- Ruby bad54
    { std::regex re("(([^X]b)+)*($|[^X]c)"); run(re, input); }

    // GOOD: ((ab)+)*ababab     -- Ruby good20
    { std::regex re("((ab)+)*ababab"); run(re, input); }
    // GOOD: ((ab)+)*abab(ab)*(ab)+  -- Ruby good21
    { std::regex re("((ab)+)*abab(ab)*(ab)+"); run(re, input); }
    // GOOD: ((ab)+)*            -- Ruby good22
    { std::regex re("((ab)+)*"); run(re, input); }
    // BAD:  ((ab)+)*$           -- Ruby bad55
    { std::regex re("((ab)+)*$"); run(re, input); }

    // -------------------------------------------------------------------------
    // 6. GOOD patterns that specifically guard against false positives.
    // -------------------------------------------------------------------------

    // GOOD: (.*,)+.+          -- Ruby good2 (no witness at the end)
    { std::regex re("(.*,)+.+"); run(re, input); }
    // GOOD: (a|.)*            -- Ruby good6
    { std::regex re("(a|.)*"); run(re, input); }
    // GOOD: (.|\n)*!          -- Ruby good7
    { std::regex re("(.|\\n)*!"); run(re, input); }
    // GOOD: ([\w.]+)*         -- Ruby good8
    { std::regex re("([\\w.]+)*"); run(re, input); }
    // GOOD: ([^\"']+)*        -- Ruby good10
    { std::regex re("([^\"']+)*"); run(re, input); }
    // GOOD: ((a|[^a])*)"      -- Ruby good10 (later)
    { std::regex re("((a|[^a])*)\""); run(re, input); }
    // GOOD: ((\s|\d)*)"       -- Ruby good11
    { std::regex re("((\\s|\\d)*)\""); run(re, input); }
    // GOOD: (\d+(X\d+)?)+     -- Ruby good12
    { std::regex re("(\\d+(X\\d+)?)+"); run(re, input); }
    // GOOD: ^([^>]+)*(>|$)    -- Ruby good15
    { std::regex re("^([^>]+)*(>|$)"); run(re, input); }
    // GOOD: (A*A*X)*          -- Ruby good24 (every witness passes through the accept state)
    { std::regex re("(A*A*X)*"); run(re, input); }
    // GOOD: ([^\\\]]+)*       -- Ruby good26
    { std::regex re("([^\\\\\\]]+)*"); run(re, input); }
    // GOOD: (a?)*b            -- Ruby good38
    { std::regex re("(a?)*b"); run(re, input); }
    // GOOD: a*b               -- Ruby good39 (linear)
    { std::regex re("a*b"); run(re, input); }
    // GOOD: (a|b)+            -- Ruby good40
    { std::regex re("(a|b)+"); run(re, input); }

    // -------------------------------------------------------------------------
    // 7. Cases that are polynomial (not exponential) — must NOT be reported by
    //    cpp/redos; the polynomial-exclusion heuristic in the shared engine
    //    should suppress them.
    // -------------------------------------------------------------------------

    // GOOD (for cpp/redos): quadratic trim (a cpp/polynomial-redos alert instead).
    { std::regex re("^\\s+|\\s+$"); run(re, input); }
    // GOOD (for cpp/redos): quadratic \d+E?\d+.
    { std::regex re("^0\\.\\d+E?\\d+$"); run(re, input); }
    // GOOD (for cpp/redos): (a|ab)*  — actually polynomial, not exponential.
    { std::regex re("^(a|ab)*$"); run(re, input); }

    // -------------------------------------------------------------------------
    // 8. Flag / dialect gating.
    // -------------------------------------------------------------------------

    // BAD: exponential regex with icase — case-insensitivity does not suppress the alert.
    { std::regex re("^([a-z]+)+$", std::regex_constants::icase); run(re, input); }
    // GOOD: non-ECMAScript grammar (basic) is excluded by the Phase 1 parser.
    { std::regex re("^(a+)+$", std::regex_constants::basic); run(re, input); }
    // GOOD: non-ECMAScript grammar (extended) is excluded.
    { std::regex re("^(a+)+$", std::regex_constants::extended); run(re, input); }
    // GOOD: non-ECMAScript grammar (awk) is excluded.
    { std::regex re("^(a+)+$", std::regex_constants::awk); run(re, input); }
    // GOOD: non-ECMAScript grammar (grep) is excluded.
    { std::regex re("^(a+)+$", std::regex_constants::grep); run(re, input); }
    // GOOD: non-ECMAScript grammar (egrep) is excluded.
    { std::regex re("^(a+)+$", std::regex_constants::egrep); run(re, input); }

    // -------------------------------------------------------------------------
    // 9. POSIX bracket sub-expressions (C++ ECMAScript-mode extension).
    //
    // std::regex under ECMAScript additionally supports POSIX bracket forms
    // (`[:name:]`, `[.sym.]`, `[=sym=]`) inside character classes. These
    // atoms must flow through the ReDoS engine correctly.
    // -------------------------------------------------------------------------

    // BAD: nested-quantifier exponential regex using a POSIX character class.
    { std::regex re("^([[:alpha:]]+)+$"); run(re, input); }
    // BAD: same pattern under icase — case-folding must not suppress the alert.
    { std::regex re("^([[:alpha:]]+)+$", std::regex_constants::icase); run(re, input); }

    return 0;
}
