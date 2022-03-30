import cpp

from FunctionCall fc
where fc.getTarget() instanceof BuiltInFunction
select fc
