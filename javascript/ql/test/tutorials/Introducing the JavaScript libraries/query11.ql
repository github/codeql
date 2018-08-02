import javascript

from VarDef def, LocalVariable v
where v = def.getAVariable() and
    not exists (VarUse use | def = use.getADef())
select def, "Dead store of local variable."
