import python

from PyFunctionObject func, ClassObject ret_type
where func.getAnInferredReturnType() = ret_type
select func.getOrigin().getLocation().getStartLine(), func.getName(), ret_type.toString()
