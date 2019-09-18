/**
 * @name Test for indexer access
 */

import csharp

from Method m, IndexerAccess e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getQualifier() instanceof ThisAccess and
  e.getIndex(0).(IntLiteral).getValue() = "0" and
  e.getIndex(1).(StringLiteral).getValue() = ""
select m, e
