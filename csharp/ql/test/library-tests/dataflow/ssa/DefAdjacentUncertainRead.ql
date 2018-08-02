import csharp

from AssignableDefinition def, AssignableRead read
where read = def.getAFirstUncertainRead()
select def.getTarget(), def, read
