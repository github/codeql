import csharp

from Ssa::SourceVariable v, Ssa::ExplicitDefinition def
where v = def.getSourceVariable()
select v, def, def.getADefinition()
