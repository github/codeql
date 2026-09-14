import csharp

from ForEachStmt stmt, int i
select stmt, i, stmt.getVariableDeclExpr(i), stmt.getVariable(i), stmt.getIterableExpr(),
  stmt.getBody()
