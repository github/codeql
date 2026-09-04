import csharp

from Ssa::SourceVariable v, SsaParameterInit def
where v = def.getSourceVariable()
select v, def, def.getParameter()
