/**
 * @name Test for as expressions
 */

import csharp

from Method m, AsExpr e
where
  m.hasName("MainIsAsCast") and
  e.getEnclosingCallable() = m and
  e.getExpr().(ParameterAccess).getTarget().getName() = "o" and
  e.getTargetType().(Class).hasFullyQualifiedName("Expressions", "Class") and
  e.getEnclosingStmt().getParent().getParent() instanceof IfStmt
select m, e
