/**
 * Provides language-specific predicates for reasoning about improper multi-character sanitization.
 */

import codeql.ruby.frameworks.core.String
private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeView
import TreeView
import codeql.regex.nfa.NfaUtils::Make<TreeView> as NfaUtils

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
