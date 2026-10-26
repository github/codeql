import csharp
import semmle.code.csharp.controlflow.Guards

from GuardedControlFlowNode gcfn, Expr sub, GuardValue v
select gcfn, gcfn.getAGuard(sub, v), sub, v
