// Minimal stubs for std::regex surface — no #include of any external header.
// Provides just enough of the std:: regex API that the C++ extractor
// creates StringLiteral nodes for each regex pattern, using real qualified
// names so a future flow-config PR can identify them unchanged.
namespace std {
  template <class CharT>
  class basic_regex {
  public:
    basic_regex(const char *s) {}
    basic_regex(const char *s, int flags) {}
    basic_regex(const wchar_t *s) {}
    basic_regex &assign(const char *s) { return *this; }
  };
  typedef basic_regex<char> regex;
  typedef basic_regex<wchar_t> wregex;

  template <class CharT>
  bool regex_match(const char *s, const basic_regex<CharT> &re) { return false; }

  template <class CharT>
  bool regex_search(const char *s, const basic_regex<CharT> &re) { return false; }

  template <class CharT>
  const char *regex_replace(const char *s, const basic_regex<CharT> &re,
                            const char *fmt) { return s; }
} // namespace std

void test() {
  // Empty
  std::regex r_empty("");

  // Basic sequence
  std::regex r_abc("abc");

  // Repetition
  std::regex r_rep1("a*b+c?d");
  std::regex r_rep2("a{4,8}");

  std::regex r_rep4("a{3,}");
  std::regex r_rep5("a{7}");

  // Alternation
  std::regex r_alt("foo|bar");

  // Character classes
  std::regex r_cc1("[abc]");
  std::regex r_cc2("[a-fA-F0-9_]");

  std::regex r_cc3("^[+-]?\\d+");
  std::regex r_cc4("[\\w]+");
  std::regex r_cc5("\\[\\][123]");
  std::regex r_cc6("[^A-Z]");
  std::regex r_cc7("[]]");   // MRI gives a warning, but accepts this as matching ']'
  std::regex r_cc8("[^]]"); // MRI gives a warning, but accepts this as matching anything except ']'
  std::regex r_cc9("[^-]");
  std::regex r_cc10("[|]");

  // Nested character classes (BAD - not parsed correctly)
  std::regex r_nested("[[a-f]A-F]");

  // POSIX bracket extensions (std::regex ECMAScript mode supports these inside [...])


  // Single POSIX classes (single outer bracket around a single POSIX expression)
  std::regex r_posix_alpha("[[:alpha:]]");   // naïve parser closes at inner ] of [:alpha:]
  std::regex r_posix_digit("[[:digit:]]");
  std::regex r_posix_space("[[:space:]]");
  std::regex r_posix_upper("[[:upper:]]");
  std::regex r_posix_lower("[[:lower:]]");
  std::regex r_posix_alnum("[[:alnum:]]");
  std::regex r_posix_print("[[:print:]]");
  std::regex r_posix_punct("[[:punct:]]");

  // POSIX class negated (outer bracket negated)
  std::regex r_posix_neg("[^[:space:]]");

  // Mixed: regular char + POSIX class inside outer bracket
  std::regex r_posix_mixed("[a[:space:]]");

  // POSIX collating symbol
  std::regex r_posix_coll("[[.a.]]");

  // POSIX equivalence class
  std::regex r_posix_equiv("[[=a=]]");

  // Mixed: POSIX class + range inside outer bracket (mis-tokenization-prone)
  std::regex r_posix_range("[[:alpha:]0-9]");

  // Meta-character classes
  std::regex r_meta1(".*");
  std::regex r_meta2("\\w+\\W");
  std::regex r_meta3("\\s\\S");
  std::regex r_meta4("\\d\\D");

  std::regex r_meta6("\\n\\r\\t");

  // NUL escape \0 (ECMAScript: valid when not followed by another digit)
  std::regex r_nul("a\\0b");

  // Anchors (ECMAScript: \b, \B only)

  std::regex r_anc2("\\b!a\\B");

  // Groups
  std::regex r_grp1("(foo)*bar");
  std::regex r_grp2("fo(o|b)ar");
  std::regex r_grp3("(a|b|cd)e");
  std::regex r_grp4("(?::+)\\w"); // Non-capturing group matching colons

  // Named groups are not supported by the ECMAScript grammar used by
  // `std::regex`, so the parser does not recognise `(?<name>...)`.


  // Backreferences
  std::regex r_bref1("(a+)b+\\1");

  // A character class combining a range with an escape class
  std::regex r_prop1("[a-f\\d]+");

  // Two separate character classes, each containing a single POSIX bracket expression
  std::regex r_posix1("[[:alpha:]][[:digit:]]");

  // A single character class containing two POSIX bracket expressions
  std::regex r_posix2("[[:alpha:][:digit:]]");

  // A single character class containing two ranges and one POSIX bracket expression
  std::regex r_posix3("[A-F[:digit:]a-f]");

  // *Not* a POSIX bracket expression; just a regular character class.
  std::regex r_posix4("[:digit:]");

  // POSIX-looking but not nested — a plain class with `:`, `a`, `l`, `p`, `h`
  std::regex r_posix5("[:alpha:]");

  // POSIX-looking tokens mid-pattern, not a real POSIX class
  std::regex r_posix6("a[:b:]c");

  // POSIX class as a range endpoint
  std::regex r_posix7("[[:alpha:]-z]");

  // Malformed — missing closing colon
  std::regex r_posix8("[[:alpha]");

  // Leading literal `]` combined with a POSIX class
  std::regex r_posix9("[]a[:alpha:]]");

  // Three POSIX classes in one class
  std::regex r_posix10("[[:alpha:][:digit:][:space:]]");

  // Additional POSIX class names
  std::regex r_posix11("[[:xdigit:]]");
  std::regex r_posix12("[[:blank:]]");
  std::regex r_posix13("[[:cntrl:]]");
  std::regex r_posix14("[[:graph:]]");

  // Integration case
  std::regex r_posix15("^([[:alpha:]]+[[:digit:]]*[[:space:]]?)+([[:punct:]]|[[:xdigit:]])+$");



  // unicode: \uHHHH 4-digit hex form (valid ECMAScript \u escape in std::regex)
  std::regex r_uni("\\u9879");
}

// Per-form location tests for C++ string-literal spellings. Each literal is
// wrapped in an appropriate std::regex use so it is extracted, and each uses
// a simple "a+b" body so term columns are predictable.
void test_locations() {
  // Plain "..." — content offset 1.
  std::regex r_plain("a+b");

  // Raw R"(...)" — content offset 3 (`R"(` = 3 chars).
  std::regex r_raw(R"(a+b)");

  // Raw with regex metacharacters — content offset 3.
  std::regex r_raw2(R"(\s+$)");

  // Complex raw — content offset 3.
  std::regex r_raw3(R"(\(([,\w]+)+\)$)");

  // Custom-delimiter raw R"x(...)x" — content offset 4 (`R"x(` = 4 chars).
  std::regex r_raw4(R"x(a+b)x");

  // Wide-char prefix L"..." — content offset 2 (`L"` = 2 chars).
  std::wregex r_wide(L"a+b");

  // Wide raw LR"(...)" — content offset 4 (`LR"(` = 4 chars).
  std::wregex r_wide_raw(LR"(a+b)");

  // Escape-containing plain — value is \s+ (2 chars); offset 1.
  // (Within-content column mapping is approximate for escaped strings.)
  std::regex r_esc1("\\s+");

  // Escape with dot — value is a\.b; offset 1.
  std::regex r_esc2("a\\.b");

  // u8 encoding prefix — content offset 3 (u8" = 3 chars). Requires C++17+.
#if __cplusplus >= 201703L
  std::regex r_u8(u8"a+b");

  // u8R raw — content offset 5 (u8R"( = 5 chars).
  std::regex r_u8_raw(u8R"(a+b)");
#endif
}
