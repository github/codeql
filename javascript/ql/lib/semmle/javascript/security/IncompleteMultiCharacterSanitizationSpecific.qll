/**
 * Provides language-specific predicates for reasoning about improper multi-character sanitization.
 */

import javascript
import semmle.javascript.security.performance.ReDoSUtil as ReDoSUtil

/**
 * A regexp term that matches substrings that should be replaced with the empty string.
 */
class EmptyReplaceRegExpTerm extends RegExpTerm {
  EmptyReplaceRegExpTerm() {
    exists(StringReplaceCall replace |
      [replace.getRawReplacement(), replace.getCallback(1).getAReturn()].mayHaveStringValue("") and
      this = replace.getRegExp().getRoot().getAChild*()
    )
  }
}
