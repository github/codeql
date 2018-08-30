/**
 * @name Local variable is initialized but not used
 * @description A local variable is initialized once, but never read or written to. Either the local variable is useless, or its value was intended to be used but is not.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/unused-initialized-local
 * @tags external/cwe/cwe-563
 */
import java
import DeadLocals

from LocalVariableDeclExpr ve, LocalVariableDecl v
where
  v = ve.getVariable() and
  not assigned(v) and
  not read(v) and
  exists(ve.getInit()) and
  not exprHasNoEffect(ve.getInit())
select v, "Local variable " + v.getName() + " is never read or written to after it is initialised."

