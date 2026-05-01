import csharp

from Ssa::SourceVariable v, Ssa::ParameterDefinition def
where v = def.getSourceVariable()
select v, def, def.getParameter()
