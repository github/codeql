import csharp

from IsExpr e, ConstantPatternExpr cpe
where cpe = e.getPattern()
select e, e.getExpr(), cpe, cpe.getValue()
