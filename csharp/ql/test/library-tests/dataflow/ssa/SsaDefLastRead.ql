import csharp

from Ssa::Definition def, AssignableRead read
where read = def.getALastRead()
select def.getSourceVariable(), def, read
