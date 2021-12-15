import csharp

from Ssa::SourceVariable v, Ssa::ImplicitCallDefinition def
where v = def.getSourceVariable()
select v, def, def.getAPossibleDefinition()
