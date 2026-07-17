// Minimal `std::regex` / `std::basic_string` stubs sufficient for the CodeQL
// C++ extractor and the ReDoS modeling tests. Real standard-library headers
// are not available inside the test extractor sandbox.

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

typedef basic_string<char>     string;
typedef basic_string<wchar_t>  wstring;

namespace regex_constants {
    // syntax_option_type constants.
    enum syntax_option_type {
        ECMAScript = 1,
        basic      = 2,
        extended   = 4,
        awk        = 8,
        grep       = 16,
        egrep      = 32,
        icase      = 256,
        nosubs     = 512,
        optimize   = 1024,
        collate    = 2048,
        multiline  = 4096
    };
    // match_flag_type constants.
    enum match_flag_type {
        match_default     = 0,
        match_not_bol     = 1,
        match_not_eol     = 2,
        match_any         = 16,
        format_default    = 0,
        format_sed        = 1,
        format_no_copy    = 4,
        format_first_only = 8
    };
    inline syntax_option_type operator|(syntax_option_type a, syntax_option_type b) {
        return (syntax_option_type)((int)a | (int)b);
    }
    inline match_flag_type operator|(match_flag_type a, match_flag_type b) {
        return (match_flag_type)((int)a | (int)b);
    }
} // namespace regex_constants

template <class CharT>
class basic_regex {
public:
    typedef regex_constants::syntax_option_type flag_type;
    basic_regex() {}
    basic_regex(const CharT* p) {}
    basic_regex(const CharT* p, flag_type f) {}
    basic_regex(const basic_string<CharT>& p) {}
    basic_regex(const basic_string<CharT>& p, flag_type f) {}
    basic_regex& assign(const CharT* p) { return *this; }
    basic_regex& assign(const CharT* p, flag_type f) { return *this; }
    basic_regex& assign(const basic_string<CharT>& p) { return *this; }
    basic_regex& assign(const basic_string<CharT>& p, flag_type f) { return *this; }
};

typedef basic_regex<char>    regex;
typedef basic_regex<wchar_t> wregex;

// smatch is a match_results<...> stub.
template <class Iter> class match_results { public: match_results() {} };
typedef match_results<const char*> cmatch;
typedef match_results<const char*> smatch;

// regex_match / regex_search overloads (subject then regex).
template <class CharT>
bool regex_match(const CharT* s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
bool regex_match(const basic_string<CharT>& s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
bool regex_match(const basic_string<CharT>& s, const basic_regex<CharT>& re,
                 regex_constants::match_flag_type) { return false; }

template <class CharT>
bool regex_search(const CharT* s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
bool regex_search(const basic_string<CharT>& s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
bool regex_search(const basic_string<CharT>& s, const basic_regex<CharT>& re,
                  regex_constants::match_flag_type) { return false; }

// regex_replace: (subject, regex, replacement).
template <class CharT>
basic_string<CharT>
regex_replace(const basic_string<CharT>& s, const basic_regex<CharT>& re,
              const basic_string<CharT>& fmt) { return basic_string<CharT>(); }
template <class CharT>
basic_string<CharT>
regex_replace(const CharT* s, const basic_regex<CharT>& re, const CharT* fmt) {
    return basic_string<CharT>();
}

// Iterator constructors: (begin, end, regex).
template <class Iter, class CharT>
class regex_iterator {
public:
    regex_iterator() {}
    regex_iterator(Iter b, Iter e, const basic_regex<CharT>& re) {}
};

template <class Iter, class CharT>
class regex_token_iterator {
public:
    regex_token_iterator() {}
    regex_token_iterator(Iter b, Iter e, const basic_regex<CharT>& re) {}
};

} // namespace std

// -----------------------------------------------------------------------------
// Phase 1 tests: syntactic constructs that the parser should recognize as
// regex terms once the strings are used as regexes.  These literals now
// flow to a `std::regex` construction site.
// -----------------------------------------------------------------------------

void basic_sequence() {
    std::regex r1("abc");                       // NOT a `RegExp` (no +, *, {n,})
}

void repetition() {
    std::regex r1("a*b+c?d");                   // RegExp
    std::regex r2("a{4,8}");                    // NOT a RegExp (bounded)
    std::regex r3("a{3,}");                     // RegExp (unbounded {n,})
    std::regex r4("a{7}");                      // NOT a RegExp
}

void alternation() {
    std::regex r1("foo|bar+");                  // RegExp
}

void character_classes() {
    std::regex r1("[abc]+");                    // RegExp
    std::regex r2("[a-fA-F0-9_]+");             // RegExp
    std::regex r3("[\\w]+");                    // RegExp
    std::regex r4("[^A-Z]*");                   // RegExp
}

void meta_classes() {
    std::regex r1(".*");                        // RegExp
    std::regex r2("\\w+\\W");                   // RegExp
    std::regex r3("\\s+\\S");                   // RegExp
    std::regex r4("\\d+\\D");                   // RegExp
}

void anchors() {
    std::regex r1("^a+bc$");                    // RegExp
    std::regex r2("\\ba+bc\\B");                // RegExp
}

void groups() {
    std::regex r1("(foo)*bar");                 // RegExp
    std::regex r2("fo(o|b+)ar");                // RegExp
    std::regex r3("(a|b|cd)e+");                // RegExp
    std::regex r4("(?::+)\\w");                 // RegExp
}

void named_groups() {
    std::regex r1("(?<id>\\w+)");               // RegExp
    std::regex r2("(?<first>[a-z]+)(?<second>[0-9]+)"); // RegExp
}

void backreferences() {
    std::regex r1("(a+)b+\\1");                 // RegExp
    std::regex r2("(?<qux>q+)\\s+\\k<qux>+");   // RegExp
}

void lookahead_lookbehind() {
    std::regex r1("(?=\\w+)abc");               // RegExp
    std::regex r2("(?!\\d+)abc");               // RegExp
    std::regex r3("a+bc(?<=\\w)");              // RegExp
    std::regex r4("a+bc(?<!\\d)");              // RegExp
}

void nested_quantifiers() {
    std::regex r1("(a+)+");                     // RegExp (ReDoS candidate)
    std::regex r2("(a*)*b");                    // RegExp (ReDoS candidate)
    std::regex r3("([a-zA-Z]+)*");              // RegExp (ReDoS candidate)
}

void complex_patterns() {
    std::regex r1("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"); // RegExp
    std::regex r2("(https?|ftp)://[^\\s/$.?#].[^\\s]*");              // RegExp
}

// -----------------------------------------------------------------------------
// Phase 2 tests: usage detection, flag detection, dialect gating.
// -----------------------------------------------------------------------------

void plain_strings() {
    // These string literals are NOT used as regexes; they must be excluded.
    const char* msg = "hello world+";           // NOT a RegExp
    std::string s("plain +string");             // NOT a RegExp
}

// A regex constructed and later matched against a subject.
void match_use() {
    std::regex r("(a+)+b");
    std::string subject("aaaaab");
    (void)std::regex_match(subject, r);
    (void)std::regex_search(subject, r);
    (void)std::regex_replace(subject, r, std::string("x"));
}

// A regex constructed with the icase flag.
void icase_construction() {
    std::regex r("foo+", std::regex_constants::icase);
    std::string s("FooO");
    (void)std::regex_match(s, r);
}

// A regex constructed with |-combined flags (icase | multiline).
void combined_flags() {
    std::regex r("bar+",
                 std::regex_constants::icase | std::regex_constants::multiline);
}

// A regex explicitly constructed with the ECMAScript grammar. Analyzed.
void explicit_ecmascript() {
    std::regex r("abc+", std::regex_constants::ECMAScript);
}

// Regexes constructed with a BRE grammar flag (`basic` or `grep`). Both
// parse as POSIX Basic Regular Expressions via `BreRegExp`. `basic` is
// backtracking-eligible; `grep` is parsed but excluded from ReDoS analysis
// by `isBacktrackingEngine` (mirroring the `extended`-vs-`egrep`/`awk`
// split for ERE).
void bre_grammar() {
    // Bare `+` is a literal in POSIX BRE, so the pattern is "abc" followed
    // by a literal `+`.
    std::regex r("abc+", std::regex_constants::basic);
    // `^` is a positional anchor (start of subexpression); bare `+` is a
    // literal.
    std::regex r2("^gr+ep",
                  std::regex_constants::grep | std::regex_constants::icase);
    // Backslash-escaped `\(...\)` groups, followed by the `*` quantifier
    // on the group; also demonstrates a bare `(...)` pair being literal.
    std::regex r3("\\(ab\\)*c.*", std::regex_constants::basic);
    std::regex r4("a(b)c.*", std::regex_constants::basic);
    // Backslash-escaped interval quantifier; bare braces are literal.
    std::regex r5("a\\{2,5\\}.*", std::regex_constants::basic);
    std::regex r6("a{2,5}.*", std::regex_constants::basic);
    // Bare `+` and `?` are literals.
    std::regex r7("a+b?.*", std::regex_constants::basic);
    // Positional `*`: literal when at start of regex; quantifier when
    // preceded by a character.
    std::regex r8("*abc.*", std::regex_constants::basic);
    std::regex r9("a*.*", std::regex_constants::basic);
    // Positional anchors: `^`/`$` at edges are anchors; mid-pattern they
    // are literals.
    std::regex r10("^a$", std::regex_constants::basic);
    std::regex r11("a^b$c.*", std::regex_constants::basic);
    // Numbered back-reference.
    std::regex r12("\\(a\\)\\1.*", std::regex_constants::basic);
    // Escaped literals: `\.` matches a literal `.`, `\*` matches `*`,
    // `\\` matches a single backslash.
    std::regex r13("\\.\\*\\\\.*", std::regex_constants::basic);
    // POSIX bracket sub-expression under BRE (inherited from the shared
    // core, unchanged).
    std::regex r14("\\([[:alpha:]]\\)*.*", std::regex_constants::basic);
    // Nested-quantifier ReDoS shape under BRE (`basic` is backtracking so
    // this can be flagged by ReDoS queries; `grep` would be parsed but
    // gated out).
    std::regex r15("\\(a*\\)*", std::regex_constants::basic);
    std::regex r16("\\([[:alpha:]]\\{1,\\}\\)\\{1,\\}",
                   std::regex_constants::basic);
    // Malformed / edge cases: unbalanced `\(`, trailing `\`, `\{` without
    // closing `\}`. These should be handled deterministically (no crash).
    std::regex r17("abc\\(def", std::regex_constants::basic);
    std::regex r18("abc\\", std::regex_constants::basic);
    std::regex r19("a\\{2,", std::regex_constants::basic);
}

// Regexes constructed with an ERE grammar flag (`extended`, `egrep`, or
// `awk`). All three parse as POSIX Extended Regular Expressions and are
// analyzed by `EreRegExp`.
void ere_grammar() {
    // Basic ERE: `+` is a quantifier as in ECMAScript.
    std::regex r1("abc+", std::regex_constants::extended);
    // POSIX bracket sub-expressions inside a character class are shared
    // across grammars.
    std::regex r2("[[:alpha:]]+", std::regex_constants::extended);
    // ERE `\.` is a literal `.`; `\(` is a literal `(`. No `\d` shorthand.
    // (Trailing `.*` so `usedAsRegex` recognises the pattern, which only
    // considers patterns with unbounded repetition.)
    std::regex r3("a\\.b\\(c\\).*", std::regex_constants::extended);
    // Grouping, alternation, bounded quantifier.
    std::regex r4("(foo|bar){2,3}", std::regex_constants::extended);
    // `awk` selects the same ERE grammar.
    std::regex r5("awk+", std::regex_constants::awk);
    // `egrep` selects the same ERE grammar.
    std::regex r6("(x|y)+", std::regex_constants::egrep);
    // Anchors and wildcard in ERE.
    std::regex r7("^a.*b$", std::regex_constants::extended);
    // Nested-quantifier signal (relevant to ReDoS on `extended`, which is
    // backtracking; `egrep`/`awk` are gated out of ReDoS queries by
    // `isBacktrackingEngine`).
    std::regex r8("([a-z]+)+", std::regex_constants::extended);
}

// A regex assigned via `.assign` with an icase flag.
void assign_flags() {
    std::regex r;
    r.assign("baz+", std::regex_constants::icase);
}

// Two match sites to test regexMatchedAgainst for multiple subjects.
void multiple_matches() {
    std::regex r("pat+ern");
    std::string a("aaa");
    std::string b("bbb");
    (void)std::regex_search(a, r);
    (void)std::regex_search(b, r);
}

// A regex constructed inline in a match call. Also should be recognized.
void inline_regex_in_match() {
    std::string s("hello");
    (void)std::regex_match(s, std::regex("hel+o"));
}

// -----------------------------------------------------------------------------
// POSIX bracket sub-expressions inside character classes.
//
// C++'s ECMAScript-mode `std::regex` grammar additionally supports POSIX
// bracket forms inside `[...]` character classes, none of which are part of
// plain ECMA-262 JavaScript. Each should parse as a single class-member atom;
// the surrounding `[...]` should have its boundary correctly detected past the
// inner `]`.
void posix_brackets() {
    std::string subj("aaa");
    // Each pattern has a trailing `.*` so it is recognised as a regex by
    // `usedAsRegex` (which only considers patterns with unbounded
    // repetition, as an optimisation).
    std::regex a("[[:alpha:]].*");
    (void)std::regex_search(subj, a);
    std::regex b("[[:digit:]]+");
    (void)std::regex_search(subj, b);
    std::regex c("[a[:space:]].*");          // mixed literal + POSIX class
    (void)std::regex_search(subj, c);
    std::regex d("[[:alpha:][:digit:]].*");  // two POSIX classes
    (void)std::regex_search(subj, d);
    std::regex e("[^[:space:]].*");          // negated
    (void)std::regex_search(subj, e);
    std::regex f("[[.a.]].*");               // collating symbol
    (void)std::regex_search(subj, f);
    std::regex g("[[=a=]].*");               // equivalence class
    (void)std::regex_search(subj, g);
    // Nested-quantifier POSIX case relevant to ReDoS.
    std::regex h("([[:alpha:]]+)+");
    (void)std::regex_search(subj, h);
}

// -----------------------------------------------------------------------------
// Adversarial POSIX-bracket parser tests. These exercise the "inside an open
// outer class" gate and its boundary logic:
//   * top-level POSIX-looking sequences (must parse as ordinary characters,
//     not as POSIX brackets - POSIX brackets only have meaning inside `[...]`);
//   * adjacent / nested classes, including the `]`-first-member special case;
//   * malformed / unterminated brackets (must not crash; behaviour recorded
//     via the `parse.expected` / `Consistency.expected` outputs);
//   * a longer performance-signal pattern combining several POSIX classes
//     with quantifiers and groups.
void posix_brackets_adversarial() {
    std::string subj("aaa");
    // Top-level `[:alpha:]` - the outer `[...]` is a character class whose
    // members are literal `:`, `a`, `l`, `p`, `h`, `:`. It must NOT be
    // recognised as a POSIX bracket.
    std::regex t1("[:alpha:].*");
    (void)std::regex_search(subj, t1);
    // Bare `a[:b:]c` - again no outer `[...]`, so `[:b:]` is a top-level
    // character class whose only member is the literal `:b:` (a range
    // between `:` and `:`, then a `b`, then another `:` ... treated
    // structurally as an ordinary character class).
    std::regex t2("a[:b:]c.*");
    (void)std::regex_search(subj, t2);
    // Three adjacent POSIX classes inside a single outer class.
    std::regex t3("[[:alpha:][:digit:][:space:]].*");
    (void)std::regex_search(subj, t3);
    // `]` as the first class member, followed by a POSIX class - exercises
    // the ]-first special case together with the POSIX-bracket gate.
    std::regex t4("[]a[:alpha:]].*");
    (void)std::regex_search(subj, t4);
    // POSIX class adjacent to what looks like a range: the `-` between the
    // POSIX class and `z` should not form a syntactic range with a POSIX
    // class as its lower bound; it should parse as three members
    // ([:alpha:], -, z) or as [:alpha:] followed by a range from `-` to
    // `z`, whichever the current parser produces (recorded in .expected).
    std::regex t5("[[:alpha:]-z].*");
    (void)std::regex_search(subj, t5);
    // Malformed: missing closing `:]` - the outer class is still valid but
    // the inner `[:alpha` has no matching `:]`, so it should NOT be
    // recognised as a POSIX bracket. The pattern should parse as an
    // ordinary character class without crashing.
    std::regex t6("[[:alpha].*");
    (void)std::regex_search(subj, t6);
    // Unterminated: outer class has no `]` at all. Behaviour is
    // implementation-defined but must be deterministic and not crash;
    // typically surfaces via Consistency/failedToParse.
    std::regex t7("[[:alpha:");
    (void)std::regex_search(subj, t7);
    // Longer combined pattern giving a basic performance signal: several
    // POSIX classes together with quantifiers and grouping.
    std::regex t8("^([[:alpha:]]+[[:digit:]]*[[:space:]]?)+([[:punct:]]|[[:xdigit:]])+$");
    (void)std::regex_search(subj, t8);
}
