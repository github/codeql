/**
 * @name Typo in equals
 * @description A method named 'equal' may be intended to be named 'equals'.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/equals-typo
 * @tags maintainability
 *       readability
 *       naming
 */

import java

from Method equal
where
  equal.hasName("equal") and
  equal.getNumberOfParameters() = 1 and
  equal.getAParamType() instanceof TypeObject and
  equal.fromSource()
select equal, "Did you mean to name this method 'equals' rather than 'equal'?"
