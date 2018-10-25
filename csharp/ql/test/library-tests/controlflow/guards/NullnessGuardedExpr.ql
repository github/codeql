import csharp
import semmle.code.csharp.controlflow.Guards

from NullnessGuardedExpr nge, Expr e, boolean isNull
where nge.isGuardedBy(e, isNull)
select nge, e, isNull
