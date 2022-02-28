import csharp

from Parameter param
where param.fromSource()
select param, param.getAnAssignedArgument()
