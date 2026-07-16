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

// A regex explicitly constructed with a non-ECMAScript grammar. Excluded.
void non_ecmascript_grammar() {
    std::regex r("abc+", std::regex_constants::basic);
    std::regex r2("[[.a.]]+", std::regex_constants::extended);
    std::regex r3("awk+", std::regex_constants::awk);
    std::regex r4("^gr+ep",
                  std::regex_constants::grep | std::regex_constants::icase);
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
