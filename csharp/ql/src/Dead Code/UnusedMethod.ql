/**
 * @name Unused method
 * @description Finds private methods that seem to never be used, or solely used from other dead methods
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/unused-method
 * @tags efficiency
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import csharp
import DeadCode

from Method m
where
  not extractionIsStandalone() and
  m.fromSource() and
  isDeadMethod(m) and
  not m.getDeclaringType().isPartial()
select m, "Unused method (or method called from dead method only)"
