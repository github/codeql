import csharp

from Ssa::SourceVariable v, SsaDefinition def
where
  v = def.getSourceVariable() and
  Ssa::isLiveOutRefParameterDefinition(def, _)
select v, def
