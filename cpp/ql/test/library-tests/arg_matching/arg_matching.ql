import cpp
import semmle.code.cpp.ir.implementation.raw.internal.VarArgs

from Call call, int argIndex, int paramIndex
where paramIndex = getParameterIndexForArgument(call, argIndex)
select call, argIndex, paramIndex
