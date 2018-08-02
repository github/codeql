import csharp

from Ssa::SourceVariable v, Ssa::ImplicitQualifierDefinition def
where v = def.getSourceVariable()
select v, def, def.getQualifierDefinition()
