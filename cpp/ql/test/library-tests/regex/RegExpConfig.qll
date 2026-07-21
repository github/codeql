/**
 * Test-only characterization: treats every C++ `StringLiteral` as a regular
 * expression so that the test corpus in `test.cpp` populates `RegExp` without
 * requiring a dataflow-based characterization.
 *
 * A production flow-config PR will narrow this to string literals that are
 * actually passed to `std::regex` / `std::basic_regex`.
 */

private import semmle.code.cpp.regex.internal.ParseRegExp

/**
 * Treats every `StringLiteral` as a `RegExp` for testing purposes.
 * Production code should restrict this to literals that are actually used as
 * regular expressions (e.g. passed to `std::regex`).
 */
class StdRegexStringLiteral extends RegExp {
  StdRegexStringLiteral() { any() }
}
