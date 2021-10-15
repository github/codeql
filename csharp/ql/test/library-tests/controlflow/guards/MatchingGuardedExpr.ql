import csharp
import semmle.code.csharp.controlflow.Guards

from GuardedExpr ge, Expr e, AbstractValues::MatchValue v, boolean match
where
  e = ge.getAGuard(e, v) and
  if v.isMatch() then match = true else match = false
select ge, e, v.getCase(), v, match
