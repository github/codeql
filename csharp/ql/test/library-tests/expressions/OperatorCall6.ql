/**
 * @name Test for user-defined operator "calls"
 */

import csharp

from Method m, OperatorCall e, Callable t
where
  m.hasName("addition") and
  e.getEnclosingCallable() = m and
  t = e.getTarget() and
  t.getName() = "+" and
  t.getDeclaringType().hasFullyQualifiedName("Expressions", "OperatorCalls+Num")
select m, e.getAnArgument(), t
