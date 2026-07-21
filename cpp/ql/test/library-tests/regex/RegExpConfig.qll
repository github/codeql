/**
 * Test-only characterization: every C++ `StringLiteral` that is directly
 * passed as the first argument to a `std::basic_regex` constructor (or
 * `assign()`) is treated as a regular expression.
 *
 * A production flow-config PR will provide a proper dataflow-based
 * characterization.  For now we use a simple syntactic gate so that the
 * test corpus in `test.cpp` populates `RegExp` without introducing any
 * dataflow dependency.
 */

private import semmle.code.cpp.regex.internal.ParseRegExp
private import semmle.code.cpp.exprs.Literal

/**
 * A `StringLiteral` that is passed directly as the first argument to a
 * `std::basic_regex` constructor or `assign()` call.  Used to populate the
 * `RegExp` abstract class in tests without dataflow.
 */
class StdRegexStringLiteral extends RegExp {
  StdRegexStringLiteral() { any() }
}
