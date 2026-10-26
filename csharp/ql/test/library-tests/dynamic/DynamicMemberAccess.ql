import csharp

from DynamicMemberAccess dma, Expr q
where q = dma.getQualifier()
select dma, dma.getLateBoundTargetName(), q
