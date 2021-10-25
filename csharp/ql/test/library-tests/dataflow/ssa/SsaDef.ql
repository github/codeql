import csharp

from Ssa::SourceVariable v, Ssa::Definition def
where v = def.getSourceVariable()
select v, def
