import cpp

from FunctionCall fc
where fc.getTarget().getName() = "printf"
select fc.getArgument(1)
