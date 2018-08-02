/**
 * @name Test for try catches
 */
import csharp

from Method m, TryStmt s
where s.getEnclosingCallable() = m
  and m.getName() = "MainTryThrow"
  and count((GeneralCatchClause)s.getACatchClause()) = 1
  and count((SpecificCatchClause)s.getACatchClause()) = 1
  and s.getCatchClause(0) instanceof SpecificCatchClause
  and s.getCatchClause(1) instanceof GeneralCatchClause
select s, s.getACatchClause()
