import cpp

from FunctionDeclarationEntry f, string noExcept, string noExceptExpr
where
  (if f.isNoExcept() then noExcept = "no except" else noExcept = "--------") and
  if exists(f.getNoExceptExpr())
  then noExceptExpr = f.getNoExceptExpr().toString()
  else noExceptExpr = "---"
select f, noExcept, noExceptExpr
