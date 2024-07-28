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

from LocalVariableDeclExpr ve, LocalVariableDecl v
where
  v = ve.getVariable() and
  not assigned(v) and
  not read(v) and
  (not exists(ve.getInit()) or exprHasNoEffect(ve.getInit())) and
  // Remove contexts where Java forces a variable declaration: enhanced-for, catch clauses and pattern cases.
  // Rules about catch clauses belong in an exception handling query
  not ve.hasImplicitInit()
select v, "Variable " + v.getName() + " is not used."
