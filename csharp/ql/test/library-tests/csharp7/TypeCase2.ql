import csharp

from TypeCase c, boolean isVar
where
  if c.getVariableDeclExpr().isImplicitlyTyped()
  then isVar=true
  else isVar=false
select c, c.getVariableDeclExpr(), c.getTypeAccess(), c.getCheckedType().toString(), isVar
