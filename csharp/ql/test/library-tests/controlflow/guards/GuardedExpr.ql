import csharp
import semmle.code.csharp.controlflow.Guards

from GuardedExpr ge, Expr sub, AbstractValue v
select ge, ge.getAGuard(sub, v), sub, v
