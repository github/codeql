import javascript

from VarDef def, VarUse use
where definitionReaches(_, def, use)
select def, use
