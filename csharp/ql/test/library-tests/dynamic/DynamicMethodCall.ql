import csharp

from DynamicMethodCall dmc, string q, int i
where if dmc.hasQualifier() then q = dmc.getQualifier().toString() else q = ""
select dmc, dmc.getLateBoundTargetName(), q, i, dmc.getArgument(i)
