import csharp
import semmle.code.csharp.controlflow.Guards

from Guard guard, Expr e1, Expr e2, boolean eqval
where guard.isEquality(e1, e2, eqval)
select guard, eqval, e1, e2
