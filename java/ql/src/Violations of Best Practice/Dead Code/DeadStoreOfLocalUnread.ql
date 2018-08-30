/**
 * @name Useless assignment to local variable
 * @description A value is assigned to a local variable, but the local variable
 *              is only read before the assignment, not after it.
 *              The assignment has no effect: either it should be removed,
 *              or the assigned value should be used.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/useless-assignment-to-local
 * @tags external/cwe/cwe-561
 */
import java
import DeadLocals

from VariableUpdate def, LocalScopeVariable v, SsaExplicitUpdate ssa
where
  def = ssa.getDefiningExpr() and
  v = ssa.getSourceVariable().getVariable() and
  deadLocal(ssa) and
  not expectedDead(ssa) and
  not overwritten(ssa) and
  read(v) and
  not def.(AssignExpr).getSource() instanceof NullLiteral and
  (def instanceof Assignment or def.(UnaryAssignExpr).getParent() instanceof ExprStmt)
select
  def, "This assignment to " + v.getName() + " is useless: the value is never read."
