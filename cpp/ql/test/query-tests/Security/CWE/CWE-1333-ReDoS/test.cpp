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
// Tests
//
// The exponential ReDoS query does not require a dataflow path from a
// user-controlled source: the vulnerable regex term itself is the alert.
// -----------------------------------------------------------------------------

void test_exp_redos(const std::string& input) {
    // BAD: classic nested-quantifier pattern with exponential backtracking.
    {
        std::regex re("^(a+)+$");
        std::regex_match(input, re);
    }

    // BAD: alternation of identical branches inside a repetition.
    {
        std::regex re("^(a|a)*$");
        std::regex_match(input, re);
    }

    // BAD: alternation with overlapping branches inside a repetition.
    {
        std::regex re("^(a|ab)*$");
        std::regex_match(input, re);
    }

    // GOOD: a linear pattern.
    {
        std::regex re("^abc.*$");
        std::regex_match(input, re);
    }

    // GOOD: a polynomial pattern -- reported by cpp/polynomial-redos when
    // reached by user input, but not by the exponential query.
    {
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(input, re, std::string(""));
    }

    // GOOD: the pattern is not used as an ECMAScript std::regex (basic
    // grammar is not modeled), so the parser does not consider it a
    // RegExp at all.
    {
        std::regex re("^(a+)+$", std::regex_constants::basic);
        std::regex_match(input, re);
    }
}
