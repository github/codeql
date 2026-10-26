import csharp
import semmle.code.csharp.controlflow.Guards

from NullGuardedExpr nge
select nge
