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
  // Removed: a{,8} — Ruby-only "{,n}" no-lower-bound quantifier (not in ECMAScript)
  std::regex r_rep4("a{3,}");
  std::regex r_rep5("a{7}");

  // Alternation
  std::regex r_alt("foo|bar");

  // Character classes
  std::regex r_cc1("[abc]");
  std::regex r_cc2("[a-fA-F0-9_]");
  // Removed: \\A[+-]?\\d+ — \\A is a Ruby-only anchor; replaced with ^ for ECMAScript
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
  // Note: commit 7 fixes tokenization for these cases; commit 6 captures pre-fix behavior.

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
  // Removed: \\h\\H — Ruby-only hex-digit escape classes (not in ECMAScript)
  std::regex r_meta6("\\n\\r\\t");

  // NUL escape \0 (ECMAScript: valid when not followed by another digit)
  std::regex r_nul("a\\0b");

  // Anchors (ECMAScript: \b, \B only; \A, \G removed)
  // Removed: \\Gabc — Ruby-only \G anchor (not in ECMAScript)
  std::regex r_anc2("\\b!a\\B");

  // Groups
  std::regex r_grp1("(foo)*bar");
  std::regex r_grp2("fo(o|b)ar");
  std::regex r_grp3("(a|b|cd)e");
  std::regex r_grp4("(?::+)\\w"); // Non-capturing group matching colons

  // Named groups
  std::regex r_ng1("(?<id>\\w+)");
  // Removed: (?'foo'fo+) — Ruby single-quote named-group form (not in ECMAScript)

  // Backreferences
  std::regex r_bref1("(a+)b+\\1");
  std::regex r_bref2("(?<qux>q+)\\s+\\k<qux>+");

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

  // Dropped: /#{A}bc/ — Ruby string interpolation, no C++ string-literal form.

  // unicode: \uHHHH 4-digit hex form (valid ECMAScript \u escape in std::regex)
  std::regex r_uni("\\u9879");
}

// Location tests (commit 8: pre-fix columns; commit 9: fixes raw/prefixed offsets).
// Each literal is wrapped in an appropriate std::regex use so the literal is in the DB.
// For each form, we test a simple "a+b" regex so the term locations are predictable.
void test_locations() {
  // Plain "..." — content offset 1 (CORRECT in current code)
  std::regex r_plain("a+b");

  // Raw R"(...)" — content offset 3 (R"( = 3 chars); currently wrong (uses 1)
  std::regex r_raw(R"(a+b)");

  // Raw with regex metacharacters — R"(\s+$)" offset 3; currently wrong
  std::regex r_raw2(R"(\s+$)");

  // Complex raw — R"(\(([,\w]+)+\)$)" offset 3; currently wrong
  std::regex r_raw3(R"(\(([,\w]+)+\)$)");

  // Custom-delimiter raw — R"x(a+b)x" offset 4 (R"x( = 4); currently wrong
  std::regex r_raw4(R"x(a+b)x");

  // Wide-char prefix L"..." — content offset 2 (L" = 2); currently wrong
  std::wregex r_wide(L"a+b");

  // Wide raw LR"(...)" — content offset 4 (LR"( = 4); currently wrong
  std::wregex r_wide_raw(LR"(a+b)");

  // Escape-containing plain — "\\s+" value is \s+ (2 chars); offset 1 correct
  // (within-content mapping is approximate for escaped strings, documented)
  std::regex r_esc1("\\s+");

  // Escape with dot — "a\\.b" value is a\.b; offset 1 correct
  std::regex r_esc2("a\\.b");
}
