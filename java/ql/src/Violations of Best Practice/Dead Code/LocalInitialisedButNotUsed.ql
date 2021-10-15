/**
 * @name Local variable is initialized but not used
 * @description A local variable that is initialized but not subsequently used may indicate an error in the code.
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
