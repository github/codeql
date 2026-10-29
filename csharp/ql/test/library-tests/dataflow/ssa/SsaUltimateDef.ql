import csharp

from Ssa::SourceVariable v, SsaDefinition def, SsaDefinition u
where
  u = def.getAnUltimateDefinition() and
  v = def.getSourceVariable()
select v, def, u
