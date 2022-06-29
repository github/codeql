/**
 * @name Suspicious regexp range
 * @description Some ranges in regular expression might match more than intended.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id rb/suspicious-regexp-range
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import codeql.ruby.security.SuspiciousRegexpRangeQuery

RegExpCharacterClass potentialMisparsedCharClass() {
  // some escapes, e.g. [\000-\037] are currently misparsed.
  result.getAChild().(RegExpNormalChar).getValue() = "\\"
  or
  // nested char classes are currently misparsed
  result.getAChild().(RegExpNormalChar).getValue() = "["
}

from RegExpCharacterRange range, string reason
where
  problem(range, reason) and
  not range.getParent() = potentialMisparsedCharClass()
select range, "Suspicious character range that " + reason + "."
