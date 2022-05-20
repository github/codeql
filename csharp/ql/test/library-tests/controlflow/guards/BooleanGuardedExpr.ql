import csharp
import semmle.code.csharp.controlflow.Guards

from GuardedExpr ge, Expr e, Access a, boolean b
where ge.isGuardedBy(e, a, b)
select ge, e, a, b
