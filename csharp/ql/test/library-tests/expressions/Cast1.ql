/**
 * @name Test for cast expressions
 */

import csharp

from Method m, CastExpr e
where
  m.hasName("MainIsAsCast") and
  e.getEnclosingCallable() = m and
  e.getExpr().(ParameterAccess).getTarget().getName() = "p" and
  e.getTargetType().(Class).hasFullyQualifiedName("Expressions", "Class") and
  e.getEnclosingStmt().getParent().getParent() instanceof IfStmt
select m, e
