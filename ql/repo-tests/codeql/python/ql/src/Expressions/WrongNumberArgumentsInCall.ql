/**
 * @name Wrong number of arguments in a call
 * @description Using too many or too few arguments in a call to a function will result in a TypeError at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-685
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/call/wrong-arguments
 */

import python
import CallArgs

from Call call, FunctionValue func, string too, string should, int limit
where
  (
    too_many_args(call, func, limit) and too = "too many arguments" and should = "no more than "
    or
    too_few_args(call, func, limit) and too = "too few arguments" and should = "no fewer than "
  ) and
  not isAbstract(func) and
  not exists(FunctionValue overridden |
    func.overrides(overridden) and correct_args_if_called_as_method(call, overridden)
  ) and
  /* The semantics of `__new__` can be a bit subtle, so we simply exclude `__new__` methods */
  not func.getName() = "__new__"
select call, "Call to $@ with " + too + "; should be " + should + limit.toString() + ".", func,
  func.descriptiveString()
