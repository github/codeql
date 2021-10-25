/**
 * @name Unused field
 * @description Finds private fields that seem to never be used, or solely used from dead methods
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/unused-field
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import csharp
import DeadCode

from Field f
where
  not extractionIsStandalone() and
  f.fromSource() and
  isDeadField(f) and
  not f.getDeclaringType().isPartial()
select f, "Unused field (or field used from dead method only)"
