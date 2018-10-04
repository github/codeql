import csharp
import semmle.code.csharp.controlflow.Guards

from MatchingGuardedExpr mge, Expr e, CaseStmt cs, boolean isMatch
where mge.isGuardedBy(e, cs, isMatch)
select mge, e, cs, isMatch
