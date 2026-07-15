#include <regex>
#include <string>

// Basic sequence
void basic_sequence() {
    std::regex r1("abc");
}

// Repetition
void repetition() {
    std::regex r1("a*b+c?d");
    std::regex r2("a{4,8}");
    std::regex r3("a{3,}");
    std::regex r4("a{7}");
}

// Alternation
void alternation() {
    std::regex r1("foo|bar");
}

// Character classes
void character_classes() {
    std::regex r1("[abc]");
    std::regex r2("[a-fA-F0-9_]");
    std::regex r3("[\\w]+");
    std::regex r4("[^A-Z]");
}

// Meta-character classes and dot
void meta_classes() {
    std::regex r1(".*");
    std::regex r2("\\w+\\W");
    std::regex r3("\\s\\S");
    std::regex r4("\\d\\D");
}

// Anchors
void anchors() {
    std::regex r1("^abc$");
    std::regex r2("\\babc\\B");
}

// Groups
void groups() {
    std::regex r1("(foo)*bar");
    std::regex r2("fo(o|b)ar");
    std::regex r3("(a|b|cd)e");
    std::regex r4("(?::+)\\w");  // Non-capturing group
}

// Named groups (ECMAScript style: (?<name>...))
void named_groups() {
    std::regex r1("(?<id>\\w+)");
    std::regex r2("(?<first>[a-z]+)(?<second>[0-9]+)");
}

// Backreferences
void backreferences() {
    std::regex r1("(a+)b+\\1");
    std::regex r2("(?<qux>q+)\\s+\\k<qux>+");
}

// Lookahead and lookbehind
void lookahead_lookbehind() {
    std::regex r1("(?=\\w)abc");
    std::regex r2("(?!\\d)abc");
    std::regex r3("abc(?<=\\w)");
    std::regex r4("abc(?<!\\d)");
}

// Nested quantifiers (relevant for ReDoS)
void nested_quantifiers() {
    std::regex r1("(a+)+");
    std::regex r2("(a*)*b");
    std::regex r3("([a-zA-Z]+)*");
}

// Complex patterns
void complex_patterns() {
    std::regex r1("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}");
    std::regex r2("(https?|ftp)://[^\\s/$.?#].[^\\s]*");
}
