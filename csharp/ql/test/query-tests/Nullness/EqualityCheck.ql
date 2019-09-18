import csharp
import semmle.code.csharp.controlflow.Guards

from Expr e1, AbstractValue v, Expr e2
select Internal::getAnEqualityCheck(e1, v, e2), v, e1, e2
