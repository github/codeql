/**
 * @name Wrong number of arguments in a class instantiation
 * @description Using too many or too few arguments in a call to the `__init__`
 *              method of a class will result in a TypeError at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-685
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/call/wrong-number-class-arguments
 */

import python
import Expressions.CallArgs

from Call call, ClassValue cls, string too, string should, int limit, FunctionValue init
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
  init = get_function_or_initializer(cls)
select call, "Call to $@ with " + too + "; should be " + should + limit.toString() + ".", init,
  init.getQualifiedName()
