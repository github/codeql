import csharp

from Ssa::SourceVariable v, SsaExplicitWrite def
where v = def.getSourceVariable()
select v, def, def.getDefinition()
