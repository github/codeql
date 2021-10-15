/**
 * @name Test for is expressions
 */

import csharp

from Method m, IsExpr e, TypePatternExpr tpe
where
  m.hasName("MainIsAsCast") and
  e.getEnclosingCallable() = m and
  e.getExpr().(ParameterAccess).getTarget().getName() = "o" and
  tpe = e.getPattern() and
  tpe.getCheckedType().(Class).hasQualifiedName("Expressions.Class")
select m, e
