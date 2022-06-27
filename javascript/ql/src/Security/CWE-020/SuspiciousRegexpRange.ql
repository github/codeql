/**
 * @name Suspicious regexp range
 * @description Some ranges in regular expression might match more than intended.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id js/suspicious-regexp-range
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import semmle.javascript.security.SuspiciousRegexpRangeQuery

from RegExpCharacterRange range, string reason
where problem(range, reason)
select range, "Suspicious character range that " + reason + "."
