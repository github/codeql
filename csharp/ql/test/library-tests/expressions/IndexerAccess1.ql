/**
 * @name Test for indexer access
 */

import csharp

from Method m, IndexerAccess e
where
  m.hasName("MainAccesses") and
  e.getEnclosingCallable() = m and
  e.getQualifier().(ParameterAccess).getTarget().hasName("other") and
  e.getIndex(0).(LocalVariableAccess).getTarget().hasName("i") and
  e.getIndex(1).(MemberConstantAccess).getTarget().hasName("constant")
select m, e
