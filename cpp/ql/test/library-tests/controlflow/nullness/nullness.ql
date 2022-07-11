import cpp

from AnalysedExpr a, LocalScopeVariable v, string isNullCheck, string isValidCheck
where
  a.getParent() instanceof IfStmt and
  v.getAnAccess().getEnclosingStmt() = a.getParent() and
  (if a.isNullCheck(v) then isNullCheck = "is null" else isNullCheck = "is not null") and
  (if a.isValidCheck(v) then isValidCheck = "is valid" else isValidCheck = "is not valid")
select a, v, isNullCheck, isValidCheck
