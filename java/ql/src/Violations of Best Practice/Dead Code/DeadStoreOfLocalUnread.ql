/**
 * @name Useless assignment to local variable
 * @description Assigning a value to a local variable that is not later used has no effect.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/useless-assignment-to-local
 * @tags external/cwe/cwe-561
 */

import java
import DeadLocals

from VariableUpdate def, LocalScopeVariable v
where
  def.getDestVar() = v and
  deadLocal(def) and
  not expectedDead(def) and
  not overwritten(def) and
  read(v) and
  not def.(AssignExpr).getSource() instanceof NullLiteral and
  (def instanceof Assignment or def.(UnaryAssignExpr).getParent() instanceof ExprStmt)
select def, "This definition of " + v.getName() + " is never used."
