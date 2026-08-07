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
//   BAD  - a cpp/redos alert is expected on the exponential-backtracking term
//   GOOD - no cpp/redos alert is expected
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
    { std::regex re("(a*)*b"); run(re, input); } // $ Alert
    // BAD: (a+)*b
    { std::regex re("(a+)*b"); run(re, input); } // $ Alert
    // BAD: (a*)+b
    { std::regex re("(a*)+b"); run(re, input); } // $ Alert
    // BAD: (a+)+b
    { std::regex re("(a+)+b"); run(re, input); } // $ Alert
    // BAD: (a*)+
    { std::regex re("^(a*)+$"); run(re, input); } // $ Alert
    // BAD: ((a+a?)*)+b+  (Ruby bad48)
    { std::regex re("(((a+a?)*)+b+)"); run(re, input); } // $ Alert
    // BAD: (a?a?)*b  (Ruby bad71)
    { std::regex re("(a?a?)*b"); run(re, input); } // $ Alert
    // BAD: (a?)+b via non-capturing alt  (Ruby bad73)
    { std::regex re("(?:a|a?)+b"); run(re, input); } // $ Alert
    // BAD: foo([\w-]*)+bar  (Ruby bad69)
    { std::regex re("foo([\\w-]*)+bar"); run(re, input); } // $ Alert
    // BAD: ((ab)*)+c  (Ruby bad70)
    { std::regex re("((ab)*)+c"); run(re, input); } // $ Alert

    // -------------------------------------------------------------------------
    // 2. Anchored nested-quantifier patterns (Ruby bad7..bad10, bad77, bad78).
    // -------------------------------------------------------------------------

    // BAD: ^([a-z]+)+$
    { std::regex re("^([a-z]+)+$"); run(re, input); } // $ Alert
    // BAD: ^([a-z]*)*$
    { std::regex re("^([a-z]*)*$"); run(re, input); } // $ Alert
    // BAD: e-mail-like regex
    { std::regex re("^([a-zA-Z0-9])(([\\.-]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$"); // $ Alert
      run(re, input); }
    // BAD: ^(([a-z])+.)+[A-Z]([a-z])+$
    { std::regex re("^(([a-z])+.)+[A-Z]([a-z])+$"); run(re, input); } // $ Alert
    // BAD: ^((a)+\w)+$
    { std::regex re("^((a)+\\w)+$"); run(re, input); } // $ Alert
    // BAD: ^(b+.)+$
    { std::regex re("^(b+.)+$"); run(re, input); } // $ Alert
    // BAD: ^ab(c+)+$  (Ruby bad66)
    { std::regex re("^ab(c+)+$"); run(re, input); } // $ Alert

    // -------------------------------------------------------------------------
    // 3. Alternations with overlapping / identical branches inside a repetition.
    // -------------------------------------------------------------------------

    // BAD: (a|a)*
    { std::regex re("^(a|a)*$"); run(re, input); } // $ Alert
    // BAD: (a|aa?)*b  (Ruby bad15)
    { std::regex re("(a|aa?)*b"); run(re, input); } // $ Alert
    // BAD: (b|a?b)*c  (Ruby bad13)
    { std::regex re("(b|a?b)*c"); run(re, input); } // $ Alert
    // BAD: (a+|b+|c+)*c  (Ruby bad47)
    { std::regex re("(a+|b+|c+)*c"); run(re, input); } // $ Alert

    // -------------------------------------------------------------------------
    // 4. Character-class / complement ambiguity (Ruby bad52, bad53, bad18,
    //    bad20, bad21, bad22, bad23, bad43).
    // -------------------------------------------------------------------------

    // BAD: ([^X]+)*$
    { std::regex re("([^X]+)*$"); run(re, input); } // $ Alert
    // BAD: (([^X]b)+)*$
    { std::regex re("(([^X]b)+)*$"); run(re, input); } // $ Alert
    // BAD: (([\S\s]|[^a])*)"
    { std::regex re("(([\\S\\s]|[^a])*)\""); run(re, input); } // $ Alert
    // BAD: ((.|[^a])*)"
    { std::regex re("((.|[^a])*)\""); run(re, input); } // $ Alert
    // BAD: ((b|[^a])*)"
    { std::regex re("((b|[^a])*)\""); run(re, input); } // $ Alert
    // BAD: (([0-9]|[^a])*)"
    { std::regex re("(([0-9]|[^a])*)\""); run(re, input); } // $ Alert
    // BAD: ^([^>a]+)*(>|$)
    { std::regex re("^([^>a]+)*(>|$)"); run(re, input); } // $ Alert

    // -------------------------------------------------------------------------
    // 5. Anchored-vs-unanchored GOOD/BAD pairs (Ruby good16/bad50,
    //    good17/bad51, good18/bad54, good20..good22/bad55). These are the
    //    high-value FP-sensitivity cases: an "accept any" tail should make the
    //    otherwise-vulnerable body safe.
    // -------------------------------------------------------------------------

    // GOOD: (a+)+aaaaa*a+     -- Ruby good16 (no rejecting suffix)
    { std::regex re("(a+)+aaaaa*a+"); run(re, input); }
    // BAD:  (a+)+aaaaa$       -- Ruby bad50
    { std::regex re("(a+)+aaaaa$"); run(re, input); } // $ Alert

    // GOOD: (\n+)+\n\n        -- Ruby good17
    { std::regex re("(\\n+)+\\n\\n"); run(re, input); }
    // BAD:  (\n+)+\n\n$       -- Ruby bad51
    { std::regex re("(\\n+)+\\n\\n$"); run(re, input); } // $ Alert

    // GOOD: (([^X]b)+)*($|[^X]b)  -- Ruby good18
    { std::regex re("(([^X]b)+)*($|[^X]b)"); run(re, input); }
    // BAD:  (([^X]b)+)*($|[^X]c)  -- Ruby bad54
    { std::regex re("(([^X]b)+)*($|[^X]c)"); run(re, input); } // $ Alert

    // GOOD: ((ab)+)*ababab     -- Ruby good20
    { std::regex re("((ab)+)*ababab"); run(re, input); }
    // GOOD: ((ab)+)*abab(ab)*(ab)+  -- Ruby good21
    { std::regex re("((ab)+)*abab(ab)*(ab)+"); run(re, input); }
    // GOOD: ((ab)+)*            -- Ruby good22
    { std::regex re("((ab)+)*"); run(re, input); }
    // BAD:  ((ab)+)*$           -- Ruby bad55
    { std::regex re("((ab)+)*$"); run(re, input); } // $ Alert

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
    // 7. Cases that are polynomial (not exponential) - must NOT be reported by
    //    cpp/redos; the polynomial-exclusion heuristic in the shared engine
    //    should suppress them.
    // -------------------------------------------------------------------------

    // GOOD (for cpp/redos): quadratic trim (a cpp/polynomial-redos alert instead).
    { std::regex re("^\\s+|\\s+$"); run(re, input); }
    // GOOD (for cpp/redos): quadratic \d+E?\d+.
    { std::regex re("^0\\.\\d+E?\\d+$"); run(re, input); }
    // GOOD (for cpp/redos): (a|ab)*  - actually polynomial, not exponential.
    { std::regex re("^(a|ab)*$"); run(re, input); }

    // -------------------------------------------------------------------------
    // 8. Flag / dialect gating.
    // -------------------------------------------------------------------------

    // BAD: exponential regex with icase - case-insensitivity does not suppress the alert.
    { std::regex re("^([a-z]+)+$", std::regex_constants::icase); run(re, input); } // $ Alert
    // BAD: BRE grammar (`basic`) is modeled by the parser (`BreRegExp`,
    // Phase D) and is backtracking-eligible, so the nested-quantifier is
    // reported as exponential. Note that `(...)` in BRE is *literal* - the
    // `\(...\)` form used in Section 12 below is the actual group syntax.
    // Here `(a+)+` parses in BRE as: literal `(`, literal `a`, literal `+`,
    // literal `)`, literal `+` - no backtracking risk, so it is *not*
    // flagged (the group-and-quantifier structure disappears).
    { std::regex re("^(a+)+$", std::regex_constants::basic); run(re, input); }
    // BAD: extended selects the ERE grammar (modeled by `EreRegExp` since
    // Phase C) and is backtracking-eligible, so the shared engine reports
    // the nested-quantifier as exponential - same as the ECMAScript case.
    { std::regex re("^(a+)+$", std::regex_constants::extended); run(re, input); } // $ Alert
    // GOOD: awk parses as ERE (same as `extended`) but is excluded from the
    // ReDoS queries by `isBacktrackingEngine` (POSIX tool-style engines are
    // treated as linear-time), *not* by any parsing/grammar difference.
    { std::regex re("^(a+)+$", std::regex_constants::awk); run(re, input); }
    // GOOD: grep selects BRE (`BreRegExp`, Phase D) - the pattern is
    // parsed, but `grep` is excluded from ReDoS analysis by
    // `isBacktrackingEngine`. (Regardless of the parse: as noted above,
    // `(a+)+` under BRE is all literals anyway.)
    { std::regex re("^(a+)+$", std::regex_constants::grep); run(re, input); }
    // GOOD: egrep parses as ERE (same as `extended`) but is excluded from
    // the ReDoS queries by `isBacktrackingEngine`, *not* by any
    // parsing/grammar difference.
    { std::regex re("^(a+)+$", std::regex_constants::egrep); run(re, input); }

    // -------------------------------------------------------------------------
    // 9. POSIX bracket sub-expressions (C++ ECMAScript-mode extension).
    //
    // std::regex under ECMAScript additionally supports POSIX bracket forms
    // (`[:name:]`, `[.sym.]`, `[=sym=]`) inside character classes. These
    // atoms must flow through the ReDoS engine correctly.
    // -------------------------------------------------------------------------

    // BAD: nested-quantifier exponential regex using a POSIX character class.
    { std::regex re("^([[:alpha:]]+)+$"); run(re, input); } // $ Alert
    // BAD: same pattern under icase - case-folding must not suppress the alert.
    { std::regex re("^([[:alpha:]]+)+$", std::regex_constants::icase); run(re, input); } // $ Alert
    // Opaque POSIX character class: `[:punct:]` has no clean `\d`/`\s`/`\w`
    // equivalent (see the discussion in RegexTreeView.qll::isEscapeClass).
    // It is therefore left as an opaque atom in the shared engine's view;
    // this pattern verifies that the parser does not crash on such inputs
    // and that (any) alerts remain deterministic. The atom flowing through
    // the engine as opaque means the shared ambiguity reasoning will not
    // detect exponential behaviour here - a documented limitation of the
    // current shared `RegexTreeViewSig`, which has no hook for
    // "opaque single-atom character class"; see the acceptance-criteria
    // discussion in the accompanying PR.
    { std::regex re("^([[:punct:]]+)+$"); run(re, input); }

    // -------------------------------------------------------------------------
    // 10. Non-backtracking POSIX tool-style grammars (`awk`, `grep`, `egrep`)
    //     combined with other flags via bitwise-OR.
    //
    // Regression guard for the `isBacktrackingEngine` gate: `awk`,
    // `egrep`, and `grep` are all parsed (`awk`/`egrep` as ERE via
    // `EreRegExp` in Phase C; `grep` as BRE via `BreRegExp` in Phase D)
    // - the same trees the `extended`/`basic` positive cases would be
    // analysed with - so suppression here is exclusively due to
    // `isBacktrackingEngine`, not any parsing/grammar difference.
    //
    // The equivalent default-grammar (ECMAScript) patterns in section 2
    // above fire, showing that the gate - not some unrelated exclusion -
    // suppresses these cases.
    // -------------------------------------------------------------------------

    // GOOD: awk grammar - non-backtracking.
    { std::regex re("^([a-z]+)+$", std::regex_constants::awk); run(re, input); }
    // GOOD: grep grammar combined with icase - non-backtracking.
    { std::regex re("^([a-z]+)+$",
                    (std::regex_constants::syntax_option_type)
                    (std::regex_constants::grep | std::regex_constants::icase));
      run(re, input); }
    // GOOD: egrep grammar combined with icase - non-backtracking.
    { std::regex re("^([a-z]+)+$",
                    (std::regex_constants::syntax_option_type)
                    (std::regex_constants::egrep | std::regex_constants::icase));
      run(re, input); }

    // -------------------------------------------------------------------------
    // 11. End-to-end ERE-grammar coverage for cpp/redos.
    //
    // These cases exercise the ERE parser (Phase C, `EreRegExp`) end-to-end
    // through the shared backtracking engine. All three flags below
    // (`extended`, `egrep`, `awk`) select the *same* grammar (ERE) and
    // therefore produce structurally-identical parse trees for the same
    // pattern string - the only axis they differ on is
    // `isBacktrackingEngine`:
    //
    //   * `extended` -> ERE + backtracking-eligible -> flagged.
    //   * `egrep` / `awk` -> ERE + non-backtracking -> NOT flagged.
    //
    // The pattern `^([a-z]+)+$` is chosen because it (a) uses only ERE-legal
    // constructs (no `\d`/`\w`/backrefs/lookaround, which are literals in
    // ERE) so the ERE parse tree is genuinely equivalent to the ECMAScript
    // one, and (b) is a known-exponential nested-quantifier shape (same as
    // the ECMAScript case at line 99 above) so we can be confident the
    // shared engine reports it.
    // -------------------------------------------------------------------------

    // BAD: ERE grammar via `extended` - parsed as ERE and backtracking-eligible.
    { std::regex re("^([a-z]+)+$", std::regex_constants::extended); run(re, input); } // $ Alert
    // GOOD: same pattern under `egrep` - parses identically as ERE but
    // excluded by `isBacktrackingEngine`.
    { std::regex re("^([a-z]+)+$", std::regex_constants::egrep); run(re, input); }
    // GOOD: same pattern under `awk` - parses identically as ERE but
    // excluded by `isBacktrackingEngine`.
    { std::regex re("^([a-z]+)+$", std::regex_constants::awk); run(re, input); }
    // GOOD: `egrep | icase` bitwise-OR combination - still ERE-parsed and
    // still excluded by `isBacktrackingEngine`; case-folding does not
    // re-enable the backtracking-engine gate.
    { std::regex re("^([a-z]+)+$",
                    (std::regex_constants::syntax_option_type)
                    (std::regex_constants::egrep | std::regex_constants::icase));
      run(re, input); }

    // -------------------------------------------------------------------------
    // 12. End-to-end BRE-grammar coverage for cpp/redos.
    //
    // These cases exercise the BRE parser (Phase D, `BreRegExp`) end-to-end
    // through the shared backtracking engine. Both flags below (`basic`,
    // `grep`) select the *same* grammar (BRE) and therefore produce
    // structurally-identical parse trees for the same pattern string - the
    // only axis they differ on is `isBacktrackingEngine`:
    //
    //   * `basic` -> BRE + backtracking-eligible -> flagged.
    //   * `grep`  -> BRE + non-backtracking     -> NOT flagged.
    //
    // BRE inverts the group / metacharacter convention relative to
    // ERE/ECMAScript: `\(...\)` are groups (bare `(...)` are literals),
    // `\{n,\}` is the interval quantifier (bare `{...}` is literal). The
    // pattern below is the BRE spelling of the ECMAScript exponential
    // shape `([a-z]+)+`. It uses only BRE-legal constructs (`\(...\)`
    // groups, `*` unlimited-repetition quantifier, a character class) so
    // its BRE parse tree is structurally equivalent to the ECMAScript one.
    // -------------------------------------------------------------------------

    // BAD: BRE grammar via `basic` - parsed as BRE and backtracking-eligible.
    // `\(a*\)*` is a classic nested-quantifier exponential shape under
    // BRE: the outer `\(...\)` is the group syntax, and both `*`s are
    // quantifiers on ambiguous content (the inner `a*` can consume any
    // prefix of a run of `a`s and the outer `*` can partition the run in
    // exponentially many ways). BRE has no `+`, so this is the BRE
    // analogue of the ECMAScript `^(a*)*$` (or the more familiar
    // `^(a+)+$`) shape.
    { std::regex re("^\\(a*\\)*$", std::regex_constants::basic); run(re, input); } // $ Alert
    // GOOD: same pattern under `grep` - parses identically as BRE but
    // excluded by `isBacktrackingEngine`.
    { std::regex re("^\\(a*\\)*$", std::regex_constants::grep); run(re, input); }
    // GOOD: `grep | icase` bitwise-OR combination - still BRE-parsed and
    // still excluded by `isBacktrackingEngine`; case-folding does not
    // re-enable the backtracking-engine gate.
    { std::regex re("^\\(a*\\)*$",
                    (std::regex_constants::syntax_option_type)
                    (std::regex_constants::grep | std::regex_constants::icase));
      run(re, input); }

    return 0;
}
