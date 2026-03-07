/**
 * @name Wrong number of arguments in a class instantiation
 * @description Using too many or too few arguments in a call to the `__init__`
 *              method of a class will result in a TypeError at runtime.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-685
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/call/wrong-number-class-arguments
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch

/**
 * Gets the number of positional arguments in `call`, including elements of any
 * literal list passed as `*args`, plus keyword arguments that don't match
 * keyword-only parameters (when the function doesn't accept `**kwargs`).
 */
int positional_arg_count(Call call, Class cls, Function init) {
  resolveClassCall(call.getAFlowNode(), cls) and
  init = DuckTyping::getInit(cls) and
  exists(int positional_keywords |
    if init.hasKwArg()
    then positional_keywords = 0
    else
      positional_keywords =
        count(Keyword kw |
          kw = call.getAKeyword() and
          not init.getAKeywordOnlyArg().getId() = kw.getArg()
        )
  |
    result =
      count(call.getAnArg()) + count(call.getStarargs().(List).getAnElt()) + positional_keywords
  )
}

/**
 * Holds if `call` constructs `cls` with too many arguments, where `limit` is the maximum.
 */
predicate too_many_args(Call call, Class cls, int limit) {
  exists(Function init |
    not init.hasVarArg() and
    // Subtract 1 from max to account for `self` parameter
    limit = init.getMaxPositionalArguments() - 1 and
    limit >= 0 and
    positional_arg_count(call, cls, init) > limit
  )
}

/**
 * Holds if `call` constructs `cls` with too few arguments, where `limit` is the minimum.
 */
predicate too_few_args(Call call, Class cls, int limit) {
  resolveClassCall(call.getAFlowNode(), cls) and
  exists(Function init |
    init = DuckTyping::getInit(cls) and
    not exists(call.getStarargs()) and
    not exists(call.getKwargs()) and
    // Subtract 1 from min to account for `self` parameter
    limit = init.getMinPositionalArguments() - 1 and
    count(call.getAnArg()) + count(call.getAKeyword()) < limit
  )
}

from Call call, Class cls, string too, string should, int limit, Function init
where
  (
    too_many_args(call, cls, limit) and
    too = "too many arguments" and
    should = "no more than "
    or
    too_few_args(call, cls, limit) and
    too = "too few arguments" and
    should = "no fewer than "
  ) and
  init = DuckTyping::getInit(cls)
select call, "Call to $@ with " + too + "; should be " + should + limit.toString() + ".", init,
  init.getQualifiedName()
