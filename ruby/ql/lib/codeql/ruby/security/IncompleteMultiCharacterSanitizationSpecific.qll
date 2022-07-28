/**
 * Provides language-specific predicates for reasoning about improper multi-character sanitization.
 */

private import codeql.ruby.frameworks.core.String
import codeql.ruby.regexp.RegExpTreeView
import codeql.ruby.security.performance.ReDoSUtil as ReDoSUtil

/**
 * A regexp term that matches substrings that should be replaced with the empty string.
 */
class EmptyReplaceRegExpTerm extends RegExpTerm {
  private StringSubstitutionCall call;

  EmptyReplaceRegExpTerm() {
    call.getReplacementString() = "" and
    this = call.getPatternRegExp().getRegExpTerm().getAChild*()
  }

  /**
   * Get the substitution call that uses this regexp term.
   */
  StringSubstitutionCall getCall() { result = call }
}
