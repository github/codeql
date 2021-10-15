import cpp

from FunctionCall fc, string returnParent
where
  if fc.getParent() instanceof ReturnStmt then returnParent = "ReturnStmt" else returnParent = ""
select fc, returnParent, fc.getEnclosingFunction(), count(fc.getTarget())
