import python

from FunctionObject func
where func.neverReturns()
select func.getOrigin().getLocation().getStartLine(), func.getName()
