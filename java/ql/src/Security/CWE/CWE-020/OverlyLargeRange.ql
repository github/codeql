/**
 * @name Overly permissive regular expression range
 * @description Overly permissive regular expression ranges match a wider range of characters than intended.
 *              This may allow an attacker to bypass a filter or sanitizer.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id java/overly-large-range
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import semmle.code.java.security.OverlyLargeRangeQuery

RegExpCharacterClass potentialMisparsedCharClass() {
  // nested char classes are currently misparsed
  result.getAChild().(RegExpNormalChar).getValue() = "["
}

from RegExpCharacterRange range, string reason
where
  problem(range, reason) and
  not range.getParent() = potentialMisparsedCharClass()
select range, "Suspicious character range that " + reason + "."
