import java

from VarAccess va, ClassObject co
where va.getVariable() = co.getInstance()
select co, va
