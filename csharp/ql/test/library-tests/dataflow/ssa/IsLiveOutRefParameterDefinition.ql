import csharp

from Ssa::SourceVariable v, Ssa::Definition def
where
  v = def.getSourceVariable() and
  def.isLiveOutRefParameterDefinition(_)
select v, def
