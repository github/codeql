import csharp

from Method m, LockStmt ls, Expr lockExpr
where
  ls.getEnclosingCallable() = m and
  m.getName() = "LockMethod" and
  lockExpr = ls.getExpr()
select ls, lockExpr, lockExpr.getType().toString(), ls.getBlock()
