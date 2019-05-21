import csharp

from IsExpr e, boolean isVar, VariablePatternExpr vpe
where
  vpe = e.getPattern() and
  if vpe.isImplicitlyTyped() then isVar = true else isVar = false
select e, vpe.getType().toString(), vpe, isVar
