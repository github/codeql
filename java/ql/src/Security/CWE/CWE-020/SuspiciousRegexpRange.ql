/**
 * @name Suspicious regexp range
 * @description Some ranges in regular expression might match more than intended.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id java/suspicious-regexp-range
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import semmle.code.java.security.SuspiciousRegexpRangeQuery

RegExpCharacterClass potentialMisparsedCharClass() {
  // nested char classes are currently misparsed
  result.getAChild().(RegExpNormalChar).getValue() = "["
}

from RegExpCharacterRange range, string reason
where
  problem(range, reason) and
  not range.getParent() = potentialMisparsedCharClass()
select range, "Suspicious character range that " + reason + "."
