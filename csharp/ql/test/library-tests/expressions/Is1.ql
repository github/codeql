/**
 * @name Test for is expressions
 */
import csharp

from Method m, IsTypeExpr e
where m.hasName("MainIsAsCast")
  and e.getEnclosingCallable() = m
  and e.getExpr().(ParameterAccess).getTarget().getName() = "o"
  and e.getCheckedType().(Class).hasQualifiedName("Expressions.Class")
select m, e

