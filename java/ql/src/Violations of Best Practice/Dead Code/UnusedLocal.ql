/**
 * @name Unused local variable
 * @description A local variable that is not initialized, assigned, or read may indicate incomplete code.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/unused-local-variable
 * @tags external/cwe/cwe-563
 */

import java
import DeadLocals

predicate exceptionVariable(LocalVariableDeclExpr ve) {
  exists(CatchClause catch | catch.getVariable() = ve)
}

predicate enhancedForVariable(LocalVariableDeclExpr ve) {
  exists(EnhancedForStmt for | for.getVariable() = ve)
}

from LocalVariableDeclExpr ve, LocalVariableDecl v
where
  v = ve.getVariable() and
  not assigned(v) and
  not read(v) and
  (not exists(ve.getInit()) or exprHasNoEffect(ve.getInit())) and
  // Remove contexts where Java forces a variable declaration: enhanced-for and catch clauses.
  // Rules about catch clauses belong in an exception handling query
  not exceptionVariable(ve) and
  not enhancedForVariable(ve)
select v,
  "Unused local variable " + v.getName() +
    ". The variable is never read or written to and should be removed."
