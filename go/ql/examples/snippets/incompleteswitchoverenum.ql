/**
 * @name Incomplete switch over enum
 * @description A switch statement of enum type should explicitly reference each
 *   of the members of that enum.
 * @kind problem
 * @id go/examples/incomplete-switch
 */

import go

from ExpressionSwitchStmt ss, DeclaredConstant c, NamedType t
where
  t.getUnderlyingType() instanceof IntegerType and
  t = ss.getExpr().getType() and
  c.getType() = t and
  forall(CaseClause case | case = ss.getACase() | not case = c.getAReference().getParent())
select ss, "This switch statement is not exhaustive: missing $@", c, c.getName()
