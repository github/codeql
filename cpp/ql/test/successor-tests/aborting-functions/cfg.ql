import cpp
import semmle.code.cpp.controlflow.internal.ConstantExprs

from Function f
where abortingFunction(f)
select f
