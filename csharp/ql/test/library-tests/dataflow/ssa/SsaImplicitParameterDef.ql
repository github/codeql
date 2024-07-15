import csharp

from Ssa::SourceVariable v, Ssa::ImplicitParameterDefinition def
where v = def.getSourceVariable()
select v, def, def.getParameter()
