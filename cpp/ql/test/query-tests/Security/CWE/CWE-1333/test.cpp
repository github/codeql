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
bool regex_search(const CharT* s, const basic_regex<CharT>& re) { return false; }
template <class CharT>
basic_string<CharT> regex_replace(const basic_string<CharT>& s, const basic_regex<CharT>& re,
                                  const basic_string<CharT>& fmt) { return basic_string<CharT>(); }

// Iterator stubs — just enough for a construction to be recognized as
// "regex used as regex" by RegexFlowConfigs.
template <class BidirIt, class CharT>
class regex_iterator {
public:
    regex_iterator() {}
    regex_iterator(BidirIt first, BidirIt last, const basic_regex<CharT>& re) {}
};

template <class BidirIt, class CharT>
class regex_token_iterator {
public:
    regex_token_iterator() {}
    regex_token_iterator(BidirIt first, BidirIt last, const basic_regex<CharT>& re) {}
};

typedef regex_iterator<const char*, char> cregex_iterator;
typedef regex_token_iterator<const char*, char> cregex_token_iterator;

} // namespace std

// -----------------------------------------------------------------------------
// Length-restricted helper stubs. These deliberately match the name-based
// heuristic in PolynomialReDoSQuery::LengthRestrictedFunction so that values
// returned from them act as barriers.
// -----------------------------------------------------------------------------

struct Request {
    std::string getHeader(const char* name) const { return std::string(); }
    std::string getRequestUri() const { return std::string(); }
    std::string getRequestUrl() const { return std::string(); }
    std::string getUserAgent() const { return std::string(); }
    std::string getPath() const { return std::string(); }         // matches "%get%path%"
    std::string getUserName() const { return std::string(); }     // matches "get%user%"
    std::string getQueryString() const { return std::string(); }  // matches "%querystring%"
};

struct Cookie {
    std::string getValue() const { return std::string(); } // Cookie::get% matches
};

// A non-restricted source: a plain member function unrelated to headers/cookies.
struct Widget {
    std::string readAll() const { return std::string(); }
};

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

// argv is a LocalFlowSource (and hence a FlowSource).
int main(int argc, char** argv) {
    std::string input(argv[1]);

    // -------------------------------------------------------------------------
    // 1. Original coverage (kept for regression stability).
    // -------------------------------------------------------------------------

    // BAD: polynomial-backtracking pattern applied to user input.
    {
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(input, re, std::string(""));
    }

    // Note: passing `argv[1]` (a raw `char*`) inline to `regex_search`
    // is not currently modeled by the Phase 2 `regexMatchedAgainst`
    // predicate (which only tracks values reaching a `std::regex`
    // variable), so no alert is expected here.
    {
        std::regex re("^\\s+|\\s+$");
        std::regex_search(argv[1], re);
    }

    // BAD: quadratic \\d+E?\\d+ pattern applied to user input.
    {
        std::regex re("^0\\.\\d+E?\\d+$");
        std::regex_search(input, re);
    }

    // GOOD: pattern is linear (a fixed prefix, no ambiguous repetition).
    {
        std::regex re("^abc.*$");
        std::regex_search(input, re);
    }

    // GOOD: input is length-restricted (a header-like getter).
    {
        Request req;
        std::string h = req.getHeader("X-Foo");
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(h, re, std::string(""));
    }

    // GOOD: input is not user-controlled.
    {
        std::string s("literal");
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // -------------------------------------------------------------------------
    // 2. Additional superlinear patterns applied to user input (BAD).
    // -------------------------------------------------------------------------

    // BAD: (a|b)*a$ — quadratic on strings of a's followed by a non-match.
    {
        std::regex re("^(a|b)*a$");
        std::regex_match(input, re);
    }

    // BAD: \s+X? repeated — quadratic on strings of whitespace.
    {
        std::regex re("\\s+X?\\s+$");
        std::regex_search(input, re);
    }

    // -------------------------------------------------------------------------
    // 3. Coverage of every modeled match API.
    // -------------------------------------------------------------------------

    // BAD: std::regex_match with user input.
    {
        std::regex re("^\\s+|\\s+$");
        std::regex_match(input, re);
    }

    // BAD: std::regex_search with user input.
    {
        std::regex re("^\\s+|\\s+$");
        std::regex_search(input, re);
    }

    // BAD: std::regex_replace with user input (already covered above; kept for
    // symmetry with the other APIs).
    {
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(input, re, std::string(""));
    }

    // BAD: std::regex_iterator constructed with a superlinear regex — the
    // literal is recognized as a std::regex pattern by Phase 2, so the
    // pattern's terms are analyzed by the polynomial ReDoS query.
    // Note: the iterator constructor does not itself take a `std::string`
    // subject, so no cpp/polynomial-redos alert is expected here; this case
    // exists to confirm the pattern literal is still parsed (a
    // cpp/redos alert would fire if the pattern were exponential).
    {
        std::regex re("^\\s+|\\s+$");
        (void)std::cregex_iterator(input.data(), input.data() + input.size(), re);
    }

    // Same for std::regex_token_iterator.
    {
        std::regex re("^\\s+|\\s+$");
        (void)std::cregex_token_iterator(input.data(), input.data() + input.size(), re);
    }

    // -------------------------------------------------------------------------
    // 4. Additional length-restricted / barrier true-negatives (GOOD).
    // -------------------------------------------------------------------------

    // GOOD: request URI is treated as length-restricted.
    {
        Request req;
        std::string s = req.getRequestUri();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: request URL is treated as length-restricted.
    {
        Request req;
        std::string s = req.getRequestUrl();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: user agent is treated as length-restricted.
    {
        Request req;
        std::string s = req.getUserAgent();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: Request::getPath matches the request/path member-getter heuristic.
    {
        Request req;
        std::string s = req.getPath();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: Request::getUserName matches the request/user member-getter heuristic.
    {
        Request req;
        std::string s = req.getUserName();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: query string is treated as length-restricted.
    {
        Request req;
        std::string s = req.getQueryString();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: Cookie::getValue matches the "cookie" class + "get%" prefix heuristic.
    {
        Cookie c;
        std::string s = c.getValue();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // GOOD: integer types are treated as small-fixed-size and act as barriers.
    // (No direct string flow, but demonstrates isSmallFixedSizeType.)
    {
        int n = argc; // integer, small fixed size
        (void)n;
        std::regex re("^\\s+|\\s+$");
        std::regex_search(input, re); // BAD (already reported above)
    }

    // -------------------------------------------------------------------------
    // 5. Non-user-controlled subjects with a superlinear pattern (GOOD).
    // -------------------------------------------------------------------------

    // GOOD: subject is a compile-time literal, not user-controlled.
    {
        std::string s("static-value");
        std::regex re("^(a|b)*a$");
        std::regex_match(s, re);
    }

    // GOOD: subject comes from an ordinary (non-source) function.
    {
        Widget w;
        std::string s = w.readAll();
        std::regex re("^\\s+|\\s+$");
        std::regex_replace(s, re, std::string(""));
    }

    // -------------------------------------------------------------------------
    // 6. Flag / dialect gating.
    // -------------------------------------------------------------------------

    // BAD: icase does not suppress the polynomial alert.
    {
        std::regex re("^\\s+|\\s+$", std::regex_constants::icase);
        std::regex_replace(input, re, std::string(""));
    }

    // GOOD: non-ECMAScript grammars (basic/extended/awk/grep/egrep) are
    // excluded by the Phase 1 parser and produce no alerts.
    {
        std::regex re("^\\s+|\\s+$", std::regex_constants::basic);
        std::regex_replace(input, re, std::string(""));
    }
    {
        std::regex re("^\\s+|\\s+$", std::regex_constants::extended);
        std::regex_replace(input, re, std::string(""));
    }
    {
        std::regex re("^\\s+|\\s+$", std::regex_constants::awk);
        std::regex_replace(input, re, std::string(""));
    }
    {
        std::regex re("^\\s+|\\s+$", std::regex_constants::grep);
        std::regex_replace(input, re, std::string(""));
    }
    {
        std::regex re("^\\s+|\\s+$", std::regex_constants::egrep);
        std::regex_replace(input, re, std::string(""));
    }

    return 0;
}
