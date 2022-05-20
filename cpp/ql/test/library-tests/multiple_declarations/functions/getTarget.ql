import cpp

from FunctionCall fc
select fc, fc.getTarget(), count(fc.getTarget())
