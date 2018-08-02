import csharp
import semmle.code.csharp.ExprOrStmtParent

from MultiImplementationsParent p
select p.toString(), p.getALocation()
