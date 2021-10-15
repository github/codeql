import cpp

from FunctionCall fc, Function f
where f = fc.getTarget()
select fc, f
