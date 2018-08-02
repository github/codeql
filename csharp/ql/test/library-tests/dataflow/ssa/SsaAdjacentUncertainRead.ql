import csharp

from Ssa::Definition def, AssignableRead read
where read = def.getAFirstUncertainRead()
select def, read
