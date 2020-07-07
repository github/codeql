/** INTERNAL - Methods used by queries that test whether functions are invoked correctly. */

import python
import Testing.Mox

private int varargs_length_objectapi(Call call) {
  not exists(call.getStarargs()) and result = 0
  or
  exists(TupleObject t | call.getStarargs().refersTo(t) | result = t.getLength())
  or
  result = count(call.getStarargs().(List).getAnElt())
}

private int varargs_length(Call call) {
  not exists(call.getStarargs()) and result = 0
  or
  exists(TupleValue t | call.getStarargs().pointsTo(t) | result = t.length())
  or
  result = count(call.getStarargs().(List).getAnElt())
}

/** Gets a keyword argument that is not a keyword-only parameter. */
private Keyword not_keyword_only_arg_objectapi(Call call, FunctionObject func) {
  func.getACall().getNode() = call and
  result = call.getAKeyword() and
  not func.getFunction().getAKeywordOnlyArg().getId() = result.getArg()
}

/** Gets a keyword argument that is not a keyword-only parameter. */
private Keyword not_keyword_only_arg(Call call, FunctionValue func) {
  func.getACall().getNode() = call and
  result = call.getAKeyword() and
  not func.getScope().getAKeywordOnlyArg().getId() = result.getArg()
}

/**
 * Gets the count of arguments that are passed as positional parameters even if they
 * are named in the call.
 * This is the sum of the number of positional arguments, the number of elements in any explicit tuple passed as *arg
 * plus the number of keyword arguments that do not match keyword-only arguments (if the function does not take **kwargs).
 */
private int positional_arg_count_for_call_objectapi(Call call, Object callable) {
  call = get_a_call_objectapi(callable).getNode() and
  exists(int positional_keywords |
    exists(FunctionObject func | func = get_function_or_initializer_objectapi(callable) |
      not func.getFunction().hasKwArg() and
      positional_keywords = count(not_keyword_only_arg_objectapi(call, func))
      or
      func.getFunction().hasKwArg() and positional_keywords = 0
    )
  |
    result = count(call.getAnArg()) + varargs_length_objectapi(call) + positional_keywords
  )
}

/**
 * Gets the count of arguments that are passed as positional parameters even if they
 * are named in the call.
 * This is the sum of the number of positional arguments, the number of elements in any explicit tuple passed as *arg
 * plus the number of keyword arguments that do not match keyword-only arguments (if the function does not take **kwargs).
 */
private int positional_arg_count_for_call(Call call, Value callable) {
  call = get_a_call(callable).getNode() and
  exists(int positional_keywords |
    exists(FunctionValue func | func = get_function_or_initializer(callable) |
      not func.getScope().hasKwArg() and
      positional_keywords = count(not_keyword_only_arg(call, func))
      or
      func.getScope().hasKwArg() and positional_keywords = 0
    )
  |
    result = count(call.getAnArg()) + varargs_length_objectapi(call) + positional_keywords
  )
}

/** Gets the number of arguments in `call`. */
int arg_count_objectapi(Call call) {
  result = count(call.getAnArg()) + varargs_length_objectapi(call) + count(call.getAKeyword())
}

/** Gets the number of arguments in `call`. */
int arg_count(Call call) {
  result = count(call.getAnArg()) + varargs_length(call) + count(call.getAKeyword())
}

/** Gets a call corresponding to the given class or function. */
private ControlFlowNode get_a_call_objectapi(Object callable) {
  result = callable.(ClassObject).getACall()
  or
  result = callable.(FunctionObject).getACall()
}

/** Gets a call corresponding to the given class or function. */
private ControlFlowNode get_a_call(Value callable) {
  result = callable.(ClassValue).getACall()
  or
  result = callable.(FunctionValue).getACall()
}

/** Gets the function object corresponding to the given class or function. */
FunctionObject get_function_or_initializer_objectapi(Object func_or_cls) {
  result = func_or_cls.(FunctionObject)
  or
  result = func_or_cls.(ClassObject).declaredAttribute("__init__")
}

/** Gets the function object corresponding to the given class or function. */
FunctionValue get_function_or_initializer(Value func_or_cls) {
  result = func_or_cls.(FunctionValue)
  or
  result = func_or_cls.(ClassValue).declaredAttribute("__init__")
}

/**Whether there is an illegally named parameter called `name` in the `call` to `func` */
predicate illegally_named_parameter_objectapi(Call call, Object func, string name) {
  not func.isC() and
  name = call.getANamedArgumentName() and
  call.getAFlowNode() = get_a_call_objectapi(func) and
  not get_function_or_initializer_objectapi(func).isLegalArgumentName(name)
}

/**Whether there is an illegally named parameter called `name` in the `call` to `func` */
predicate illegally_named_parameter(Call call, Value func, string name) {
  not func.isBuiltin() and
  name = call.getANamedArgumentName() and
  call.getAFlowNode() = get_a_call(func) and
  not get_function_or_initializer(func).isLegalArgumentName(name)
}

/**Whether there are too few arguments in the `call` to `callable` where `limit` is the lowest number of legal arguments */
predicate too_few_args_objectapi(Call call, Object callable, int limit) {
  // Exclude cases where an incorrect name is used as that is covered by 'Wrong name for an argument in a call'
  not illegally_named_parameter_objectapi(call, callable, _) and
  not exists(call.getStarargs()) and
  not exists(call.getKwargs()) and
  arg_count_objectapi(call) < limit and
  exists(FunctionObject func | func = get_function_or_initializer_objectapi(callable) |
    call = func.getAFunctionCall().getNode() and
    limit = func.minParameters() and
    // The combination of misuse of `mox.Mox().StubOutWithMock()`
    // and a bug in mox's implementation of methods results in having to
    // pass 1 too few arguments to the mocked function.
    not (useOfMoxInModule(call.getEnclosingModule()) and func.isNormalMethod())
    or
    call = func.getAMethodCall().getNode() and limit = func.minParameters() - 1
    or
    callable instanceof ClassObject and
    call.getAFlowNode() = get_a_call_objectapi(callable) and
    limit = func.minParameters() - 1
  )
}

/**Whether there are too few arguments in the `call` to `callable` where `limit` is the lowest number of legal arguments */
predicate too_few_args(Call call, Value callable, int limit) {
  // Exclude cases where an incorrect name is used as that is covered by 'Wrong name for an argument in a call'
  not illegally_named_parameter(call, callable, _) and
  not exists(call.getStarargs()) and
  not exists(call.getKwargs()) and
  arg_count(call) < limit and
  exists(FunctionValue func | func = get_function_or_initializer(callable) |
    call = func.getAFunctionCall().getNode() and
    limit = func.minParameters() and
    /*
     * The combination of misuse of `mox.Mox().StubOutWithMock()`
     * and a bug in mox's implementation of methods results in having to
     * pass 1 too few arguments to the mocked function.
     */

    not (useOfMoxInModule(call.getEnclosingModule()) and func.isNormalMethod())
    or
    call = func.getAMethodCall().getNode() and limit = func.minParameters() - 1
    or
    callable instanceof ClassValue and
    call.getAFlowNode() = get_a_call(callable) and
    limit = func.minParameters() - 1
  )
}

/**Whether there are too many arguments in the `call` to `func` where `limit` is the highest number of legal arguments */
predicate too_many_args_objectapi(Call call, Object callable, int limit) {
  // Exclude cases where an incorrect name is used as that is covered by 'Wrong name for an argument in a call'
  not illegally_named_parameter_objectapi(call, callable, _) and
  exists(FunctionObject func |
    func = get_function_or_initializer_objectapi(callable) and
    not func.getFunction().hasVarArg() and
    limit >= 0
  |
    call = func.getAFunctionCall().getNode() and limit = func.maxParameters()
    or
    call = func.getAMethodCall().getNode() and limit = func.maxParameters() - 1
    or
    callable instanceof ClassObject and
    call.getAFlowNode() = get_a_call_objectapi(callable) and
    limit = func.maxParameters() - 1
  ) and
  positional_arg_count_for_call_objectapi(call, callable) > limit
}

/**Whether there are too many arguments in the `call` to `func` where `limit` is the highest number of legal arguments */
predicate too_many_args(Call call, Value callable, int limit) {
  // Exclude cases where an incorrect name is used as that is covered by 'Wrong name for an argument in a call'
  not illegally_named_parameter(call, callable, _) and
  exists(FunctionValue func |
    func = get_function_or_initializer(callable) and
    not func.getScope().hasVarArg() and
    limit >= 0
  |
    call = func.getAFunctionCall().getNode() and limit = func.maxParameters()
    or
    call = func.getAMethodCall().getNode() and limit = func.maxParameters() - 1
    or
    callable instanceof ClassValue and
    call.getAFlowNode() = get_a_call(callable) and
    limit = func.maxParameters() - 1
  ) and
  positional_arg_count_for_call(call, callable) > limit
}

/** Holds if `call` has too many or too few arguments for `func` */
predicate wrong_args_objectapi(Call call, FunctionObject func, int limit, string too) {
  too_few_args_objectapi(call, func, limit) and too = "too few"
  or
  too_many_args_objectapi(call, func, limit) and too = "too many"
}

/** Holds if `call` has too many or too few arguments for `func` */
predicate wrong_args(Call call, FunctionValue func, int limit, string too) {
  too_few_args(call, func, limit) and too = "too few"
  or
  too_many_args(call, func, limit) and too = "too many"
}

/**
 * Holds if `call` has correct number of arguments for `func`.
 * Implies nothing about whether `call` could call `func`.
 */
bindingset[call, func]
predicate correct_args_if_called_as_method_objectapi(Call call, FunctionObject func) {
  arg_count_objectapi(call) + 1 >= func.minParameters() and
  arg_count_objectapi(call) < func.maxParameters()
}

/**
 * Holds if `call` has correct number of arguments for `func`.
 * Implies nothing about whether `call` could call `func`.
 */
bindingset[call, func]
predicate correct_args_if_called_as_method(Call call, FunctionValue func) {
  arg_count(call) + 1 >= func.minParameters() and
  arg_count(call) < func.maxParameters()
}

/** Holds if `call` is a call to `overriding`, which overrides `func`. */
predicate overridden_call_objectapi(FunctionObject func, FunctionObject overriding, Call call) {
  overriding.overrides(func) and
  overriding.getACall().getNode() = call
}

/** Holds if `call` is a call to `overriding`, which overrides `func`. */
predicate overridden_call(FunctionValue func, FunctionValue overriding, Call call) {
  overriding.overrides(func) and
  overriding.getACall().getNode() = call
}

/** Holds if `func` will raise a `NotImplemented` error. */
predicate isAbstract(FunctionValue func) {
  func.getARaisedType() = ClassValue::notImplementedError()
}
