/**
 * @name Test for operators
 */

import csharp

from IncrementOperator o
where
  o.getDeclaringType().hasFullyQualifiedName("Operators", "IntVector") and
  o.getReturnType() = o.getDeclaringType() and
  o.getParameter(0).getType() = o.getDeclaringType()
select o, o.getReturnType()
