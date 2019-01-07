import csharp

from Ssa::SourceVariable v, Ssa::Definition def, Ssa::Definition u
where
  u = def.getAnUltimateDefinition() and
  v = def.getSourceVariable()
select v, def, u
