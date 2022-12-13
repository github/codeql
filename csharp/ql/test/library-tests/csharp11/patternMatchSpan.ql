import csharp

from PatternMatch pm
where pm.getFile().getStem() = "PatternMatchSpan"
select pm.getExpr().getType().getName(), pm.getPattern(), pm.getPattern().getType().getName()
