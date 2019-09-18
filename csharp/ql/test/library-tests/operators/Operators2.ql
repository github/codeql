/**
 * @name Test for operators
 */

import csharp

from IncrementOperator o
where
  o.getDeclaringType().hasQualifiedName("Operators", "IntVector") and
  o.getStatementBody().getStmt(2) instanceof ReturnStmt
select o, o.getReturnType()
