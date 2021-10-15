/**
 * Utilities for determining which parameters and arguments correspond to the `...` parameter for
 * varargs functions.
 */

private import cpp

/**
 * Gets the index of the `...` parameter, if any. If present, the value will always be equal to
 * `func.getNumberOfParameters()`.
 */
int getEllipsisParameterIndexForFunction(Function func) {
  func.isVarargs() and result = func.getNumberOfParameters()
}

/**
 * Gets the index of the `...` parameter, if any.
 */
int getEllipsisParameterIndexForRoutineType(RoutineType type) {
  // Since the extractor doesn't record this information directly, we look for routine types whose
  // last parameter type is `UnknownType`.
  type.getParameterType(result) instanceof UnknownType and
  result = strictcount(type.getAParameterType()) - 1
}

/**
 * Gets the index of the `...` parameter, if any. This will be one greater than the index of the
 * last declared positional parameter.
 */
int getEllipsisParameterIndex(Call call) {
  exists(FunctionCall funcCall |
    funcCall = call and
    if funcCall.getTargetType() instanceof RoutineType
    then result = getEllipsisParameterIndexForRoutineType(funcCall.getTargetType())
    else result = getEllipsisParameterIndexForFunction(funcCall.getTarget())
  )
  or
  exists(ExprCall exprCall |
    exprCall = call and
    result = getEllipsisParameterIndexForRoutineType(exprCall.getExpr().getType().stripType())
  )
}

/**
 * Gets the index of the parameter that will be initialized with the value of the argument
 * specified by `argIndex`. For ordinary positional parameters, the argument and parameter indices
 * will be equal. For a call to a varargs function, all arguments passed to the `...` will be
 * mapped to the index returned by `getEllipsisParameterIndex()`.
 */
int getParameterIndexForArgument(Call call, int argIndex) {
  exists(call.getArgument(argIndex)) and
  if argIndex >= getEllipsisParameterIndex(call)
  then result = getEllipsisParameterIndex(call)
  else result = argIndex
}

/**
 * Holds if the argument specified by `index` is an argument to the `...` of a varargs function.
 */
predicate isEllipsisArgumentIndex(Call call, int index) {
  exists(call.getArgument(index)) and index >= getEllipsisParameterIndex(call)
}
