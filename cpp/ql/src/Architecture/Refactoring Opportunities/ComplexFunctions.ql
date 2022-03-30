/**
 * @name Complex functions
 * @description Finds functions which call too many other functions. Splitting these functions would increase maintainability and readability.
 * @kind problem
 * @id cpp/architecture/complex-functions
 * @problem.severity recommendation
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import cpp

from Function f, int n
where
  f.fromSource() and
  n = f.getMetrics().getNumberOfCalls() and
  n > 99 and
  not f.isMultiplyDefined()
select f as Function, "This function makes too many calls (" + n.toString() + ")"
