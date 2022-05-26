/**
 * @name Finalizer nulls fields
 * @description Setting fields to 'null' in a finalizer does not cause the object to be collected
 *              by the garbage collector any earlier, and may adversely affect performance.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/finalizer-nulls-fields
 * @tags efficiency
 *       maintainability
 */

import java

from FinalizeMethod m, Assignment assign, FieldAccess lhs, NullLiteral null
where
  assign.getEnclosingCallable() = m and
  null.getParent() = assign and
  lhs = assign.getDest() and
  lhs.getField().getDeclaringType() = m.getDeclaringType().getAnAncestor() and
  m.fromSource()
select assign, "Finalizer nulls fields."
