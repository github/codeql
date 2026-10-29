import csharp

from DynamicElementAccess dea, int i, boolean b
where if dea.isConditional() then b = true else b = false
select dea, dea.getQualifier(), b, i, dea.getIndex(i)
