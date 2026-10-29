import javascript

from SsaVariable def, VarUse use
where def.getAUse() = use
select def, use
