/**
 * @name Overly permissive regular expression range
 * @description Overly permissive regular expression ranges match a wider range of characters than intended.
 *              This may allow an attacker to bypass a filter or sanitizer.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id js/overly-large-range
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import semmle.javascript.security.OverlyLargeRangeQuery

from RegExpCharacterRange range, string reason
where problem(range, reason)
select range, "Suspicious character range that " + reason + "."
