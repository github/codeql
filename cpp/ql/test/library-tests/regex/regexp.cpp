// semmle-extractor-options: -std=c++20

namespace std {
  template <class CharT>
  class basic_regex {
  public:
    basic_regex(const CharT *s) {}
    basic_regex(const CharT *s, int flags) {}
    basic_regex &assign(const CharT *s) { return *this; }
  };
  typedef basic_regex<char> regex;
} // namespace std

// Empty
std::regex r_empty("");

// Basic sequence
std::regex r_abc("abc");

// Repetition
std::regex r_rep1("a*b+c?d");
std::regex r_rep2("a{4,8}");
std::regex r_rep3("a{3,}");
std::regex r_rep4("a{7}");

// Alternation
std::regex r_alt("foo|bar");

// Character classes
std::regex r_cc1("[abc]");
std::regex r_cc2("[a-fA-F0-9_]");
std::regex r_cc3("[\\w]+");
std::regex r_cc4("\\[\\][123]");
std::regex r_cc5("[^A-Z]");
std::regex r_cc6("[]]");   // MRI gives a warning, but accepts this as matching ']'
std::regex r_cc7("[^]]"); // MRI gives a warning, but accepts this as matching anything except ']'
std::regex r_cc8("[^-]");
std::regex r_cc9("[|]");

// Nested character classes (BAD - not parsed correctly)
std::regex r_nested("[[a-f]A-F]");

// Meta-character classes
std::regex r_meta1(".*");
std::regex r_meta2("\\w+\\W");
std::regex r_meta3("\\s\\S");
std::regex r_meta4("\\d\\D");
std::regex r_meta5("\\n\\r\\t");

// Anchors
std::regex r_anc1("\\b!a\\B");

// Groups
std::regex r_grp1("(foo)*bar");
std::regex r_grp2("fo(o|b)ar");
std::regex r_grp3("(a|b|cd)e");
std::regex r_grp4("(?::+)\\w"); // Non-capturing group matching colons

// Backreferences
std::regex r_bref1("(a+)b+\\1");

// Named character properties using a single POSIX bracket expression
std::regex r_prop1("[[:alnum:]]*");
std::regex r_prop2("[[:digit:]]+");
std::regex r_prop3("[[:alnum:]]{2,3}");
std::regex r_prop4("[a-f[:digit:]]+"); // Also valid inside character classes

// Two separate character classes, each containing a single POSIX bracket expression
std::regex r_posix1("[[:alpha:]][[:digit:]]");

// A single character class containing two POSIX bracket expressions
std::regex r_posix2("[[:alpha:][:digit:]]");

// A single character class containing two ranges and one POSIX bracket expression
std::regex r_posix3("[A-F[:digit:]a-f]");

// POSIX collating symbols
std::regex r_posix_coll1("[[.a.]]");
std::regex r_posix_coll2("[A-F[.b.]a-f]");

// *Not* a POSIX bracket expression; just a regular character class.
std::regex r_posix4("[:digit:]");

// unicode
std::regex r_uni("\\u{9879}");

// control escapes
std::regex r_ctrl1("\\cA");
std::regex r_ctrl2("[\\cZ]");

// NUL escape
std::regex r_nul1("\\0");
std::regex r_nul2("[\\0]");

// String literal spellings for location tests
std::regex r_loc_plain("a\\nb");
std::basic_regex<wchar_t> r_loc_L(L"a\\nc");
std::basic_regex<char8_t> r_loc_u8(u8"a\\nc");
std::basic_regex<char16_t> r_loc_u(u"a\\nc");
std::basic_regex<char32_t> r_loc_U(U"a\\nc");
std::regex r_loc_R(R"(a\nc)");
std::basic_regex<wchar_t> r_loc_LR(LR"(a\nc)");
std::basic_regex<char8_t> r_loc_u8R(u8R"(a\nc)");
std::basic_regex<char16_t> r_loc_uR(uR"(a\nc)");
std::basic_regex<char32_t> r_loc_UR(UR"(a\nc)");
std::regex r_loc_Rx(R"x(a\nc)x");
std::regex r_loc_Rfoo(R"foo(a\nc)foo");
