import csharp
import semmle.code.csharp.controlflow.Guards

from GuardedControlFlowNode gcfn, Expr sub, AbstractValue v
select gcfn, gcfn.getAGuard(sub, v), sub, v
