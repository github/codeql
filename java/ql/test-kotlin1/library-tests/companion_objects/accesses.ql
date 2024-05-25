import java

from VarAccess va, CompanionObject cco
where va.getVariable() = cco.getInstance()
select cco, va
