/**
 * @name Assignment in return statement
 * @description Assigning to a local variable in a 'return' statement has no effect.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/assignment-in-return
 * @tags maintainability
 *       readability
 */

import java

from AssignExpr e, LocalVariableDecl v
where
  e.getDest().(VarAccess).getVariable() = v and
  e.getParent+() instanceof ReturnStmt
select e, "Assignment to a local variable in a return statement may have no effect."
