import java

from VarAccess va, ClassCompanionObject cco
where va.getVariable() = cco.getInstance()
select cco, va
