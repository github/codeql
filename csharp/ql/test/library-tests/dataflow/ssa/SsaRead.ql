import csharp

from Ssa::SourceVariable v, Ssa::Definition def, AssignableRead read
where
  read = def.getARead() and
  v = def.getSourceVariable()
select v, def, read
