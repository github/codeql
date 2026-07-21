/**
 * Minimal stubs for std::regex so that the test corpus compiles hermetically
 * without including any external/standard headers.
 *
 * The qualified names (std::basic_regex, std::regex, std::regex_match, ...) match
 * the real C++ standard library names so that future flow-config PRs can identify
 * them without any test rework.
 */
namespace std {

template <class CharT>
class basic_regex {
public:
  basic_regex() {}
  explicit basic_regex(const char* pattern) {}
  explicit basic_regex(const char* pattern, unsigned flags) {}
  basic_regex& assign(const char* pattern) { return *this; }
};

typedef basic_regex<char> regex;

// Minimal free-function stubs (subject types use const char* to avoid pulling in <string>)
template <class CharT>
bool regex_match(const char* s, const basic_regex<CharT>& re) { return false; }

template <class CharT>
bool regex_search(const char* s, const basic_regex<CharT>& re) { return false; }

template <class CharT>
const char* regex_replace(const char* s, const basic_regex<CharT>& re, const char* fmt) {
  return s;
}

} // namespace std

// ---------------------------------------------------------------------------
// Test corpus — each regex is wrapped in a std::regex construction or use.
// ---------------------------------------------------------------------------

void test_empty() {
  // Empty pattern
  std::regex re1("");
}

void test_basic_sequence() {
  // Basic sequence
  std::regex re("abc");
}

void test_repetition() {
  std::regex re1(R"(a*b+c?d)");
  std::regex re2(R"(a{4,8})");
  std::regex re3(R"(a{3,})");
  std::regex re4(R"(a{7})");
}

void test_alternation() {
  std::regex re(R"(foo|bar)");
}

void test_character_classes() {
  std::regex re1(R"([abc])");
  std::regex re2(R"([a-fA-F0-9_])");
  std::regex re3(R"([+-]?\d+)"); // Note: \d is a value-level \d
  std::regex re4(R"([\w]+)");
  std::regex re5(R"(\[\][123])");
  std::regex re6(R"([^A-Z])");
  std::regex re7(R"([]])");   // matches ']'
  std::regex re8(R"([^]])");  // matches anything except ']'
  std::regex re9(R"([^-])");
  std::regex re10(R"([|])");
}

void test_meta_character_classes() {
  std::regex re1(R"(.*)");
  std::regex re2(R"(\w+\W)");
  std::regex re3(R"(\s\S)");
  std::regex re4(R"(\d\D)");
  std::regex re5(R"(\n\r\t)");
}

void test_anchors() {
  std::regex re1(R"(\b!a\B)");
}

void test_groups() {
  std::regex re1(R"((foo)*bar)");
  std::regex re2(R"(fo(o|b)ar)");
  std::regex re3(R"((a|b|cd)e)");
  std::regex re4(R"((?::+)\w)"); // Non-capturing group
}

void test_named_groups() {
  std::regex re1(R"((?<id>\w+))");
}

void test_backreferences() {
  std::regex re1(R"((a+)b+\1)");
  std::regex re2(R"((?<qux>q+)\s+\k<qux>+)");
}

// Two separate character classes, each containing a single POSIX bracket expression
void test_posix_separate() {
  std::regex re(R"([[:alpha:]][[:digit:]])");
}

// A single character class containing two POSIX bracket expressions
void test_posix_combined() {
  std::regex re(R"([[:alpha:][:digit:]])");
}

// A single character class containing two ranges and one POSIX bracket expression
void test_posix_mixed() {
  std::regex re(R"([A-F[:digit:]a-f])");
}

// *Not* a POSIX bracket expression; just a regular character class.
void test_posix_not_posix() {
  std::regex re(R"([:digit:])");
}

// Unicode escape
void test_unicode() {
  std::regex re(R"(\u0041)");
}

// Lookahead / lookbehind assertions
void test_lookaround() {
  std::regex re1(R"((?=\w))");   // positive lookahead
  std::regex re2(R"((?!\n))");   // negative lookahead
  std::regex re3(R"((?<=\.))");  // positive lookbehind
  std::regex re4(R"((?<!\\))");  // negative lookbehind
}
