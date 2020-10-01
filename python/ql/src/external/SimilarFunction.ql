/**
 * @deprecated
 * @name Similar function
 * @description There is another function that is very similar this one. Extract the common code to a common function to improve sharing.
 * @kind problem
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @problem.severity recommendation
 * @sub-severity low
 * @precision very-high
 * @id py/similar-function
 */

import python
import CodeDuplication

predicate relevant(Function m) { m.getMetrics().getNumberOfLinesOfCode() > 10 }

from Function m, Function other, string message, int percent
where
  similarScopes(m, other, percent, message) and
  relevant(m) and
  percent > 95.0 and
  not duplicateScopes(m, other, _, _) and
  not duplicateScopes(m.getEnclosingModule(), other.getEnclosingModule(), _, _) and
  not duplicateScopes(m.getScope(), other.getScope(), _, _)
select m, message, other, other.getName()
