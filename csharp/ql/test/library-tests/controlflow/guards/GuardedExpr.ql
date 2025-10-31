import csharp
import semmle.code.csharp.controlflow.Guards

from GuardedExpr ge, Expr sub, GuardValue v
select ge, ge.getAGuard(sub, v), sub, v
