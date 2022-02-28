import csharp

from AssignableDefinition def
where def.getElement().fromSource()
select def, def.getAControlFlowNode()
