/**
 * @name Test for checked expression
 */

import csharp

from Method m, CheckedExpr e
where
  m.hasName("MainChecked") and
  e.getEnclosingCallable() = m and
  e.getExpr().(PropertyAccess).getTarget().hasName("Name")
select m, e
