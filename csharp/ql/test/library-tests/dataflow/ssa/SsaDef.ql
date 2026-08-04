import csharp

from Ssa::SourceVariable v, SsaDefinition def
where v = def.getSourceVariable()
select v, def
