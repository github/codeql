/**
 * @deprecated
 * @name Duplicate function
 * @description There is another identical implementation of this function. Extract the code to a common file or superclass to improve sharing.
 * @kind problem
 * @tags testability
 *       useless-code
 *       maintainability
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/duplicate-function
 */

import python
import CodeDuplication

predicate relevant(Function m) { m.getMetrics().getNumberOfLinesOfCode() > 5 }

from Function m, Function other, string message, int percent
where
  duplicateScopes(m, other, percent, message) and
  relevant(m) and
  percent > 95.0 and
  not duplicateScopes(m.getEnclosingModule(), other.getEnclosingModule(), _, _) and
  not duplicateScopes(m.getScope(), other.getScope(), _, _)
select m, message, other, other.getName()
