import cpp

from Call call, int argIndex, int paramIndex
where
    paramIndex = call.getParameterIndexForArgument(argIndex)
select call, argIndex, paramIndex
