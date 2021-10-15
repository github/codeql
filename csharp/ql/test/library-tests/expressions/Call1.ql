/**
 * @name Test for calls
 */

import csharp

from StaticConstructor c, MethodCall e
where
  c.hasName("Class") and
  e.getEnclosingCallable() = c and
  e.hasNoArguments() and
  e.getEnclosingStmt() = c.getStatementBody().getStmt(2) and
  not exists(e.getQualifier())
select c, e
