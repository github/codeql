import csharp

from AssignableDefinition def, AssignableRead read
where read = def.getAFirstRead()
select def.getTarget(), def, read
