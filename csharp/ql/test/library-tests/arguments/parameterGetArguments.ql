import csharp

from Parameter param
where param.getCallable().fromSource()
select param, param.getAnAssignedArgument()
