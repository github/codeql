import csharp

from IsPatternExpr e, boolean isVar
where
  if e.getVariableDeclExpr().isImplicitlyTyped()
  then isVar=true
  else isVar=false
select e, e.getTypeAccess(), e.getCheckedType().toString(), e.getVariableDeclExpr(), isVar
