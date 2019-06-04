import csharp

from Case c
where c.getPattern() instanceof VariablePatternExpr
select c, c.getCondition()
