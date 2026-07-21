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
    basic_regex &assign(const char *s) { return *this; }
  };
  typedef basic_regex<char> regex;

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
  std::regex r_cc3("\\A[+-]?\\d+");
  std::regex r_cc4("[\\w]+");
  std::regex r_cc5("\\[\\][123]");
  std::regex r_cc6("[^A-Z]");
  std::regex r_cc7("[]]");   // MRI gives a warning, but accepts this as matching ']'
  std::regex r_cc8("[^]]"); // MRI gives a warning, but accepts this as matching anything except ']'
  std::regex r_cc9("[^-]");
  std::regex r_cc10("[|]");

  // Nested character classes (BAD - not parsed correctly)
  std::regex r_nested("[[a-f]A-F]");

  // Meta-character classes
  std::regex r_meta1(".*");
  // Removed: /.*/m mode variant — in C++, flags are passed as constructor arg (out of scope)
  std::regex r_meta2("\\w+\\W");
  std::regex r_meta3("\\s\\S");
  std::regex r_meta4("\\d\\D");
  std::regex r_meta5("\\h\\H");
  std::regex r_meta6("\\n\\r\\t");

  // Anchors
  std::regex r_anc1("\\Gabc");
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

  // Named character properties using the p-style syntax
  std::regex r_prop1("\\p{Word}*");
  std::regex r_prop2("\\P{Digit}+");
  std::regex r_prop3("\\p{^Alnum}{2,3}");
  std::regex r_prop4("[a-f\\p{Digit}]+"); // Also valid inside character classes

  // Two separate character classes, each containing a single POSIX bracket expression
  std::regex r_posix1("[[:alpha:]][[:digit:]]");

  // A single character class containing two POSIX bracket expressions
  std::regex r_posix2("[[:alpha:][:digit:]]");

  // A single character class containing two ranges and one POSIX bracket expression
  std::regex r_posix3("[A-F[:digit:]a-f]");

  // *Not* a POSIX bracket expression; just a regular character class.
  std::regex r_posix4("[:digit:]");

  // Dropped: /#{A}bc/ — Ruby string interpolation, no C++ string-literal form.

  // unicode: \u{9879} in C++ (Ruby unicode escape syntax)
  std::regex r_uni("\\u{9879}");
}
