import csharp

from Case c, boolean isVar, VariablePatternExpr vpe
where
  vpe = c.getPattern() and
  if vpe.isImplicitlyTyped() then isVar = true else isVar = false
select c, vpe, vpe.getType().toString(), isVar
