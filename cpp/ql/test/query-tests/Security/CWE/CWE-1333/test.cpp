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

} // namespace std

// Header-name helpers that the query treats as length-restricted.
struct Request {
    std::string getHeader(const char* name) const { return std::string(); }
};

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

// argv is a LocalFlowSource (and hence a FlowSource).
int main(int argc, char** argv) {
    std::string input(argv[1]);

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

    return 0;
}
