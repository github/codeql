/**
 * @name Mismatch between signature and use of an overridden method
 * @description Method has a signature that differs from both the signature of its overriding methods and
 *              the arguments with which it is called, and if it were called, would be likely to cause an error.
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/inheritance/incorrect-overridden-signature
 */

import python
import Expressions.CallArgs

from Call call, FunctionValue func, FunctionValue overriding, string problem
where
  not func.getName() = "__init__" and
  overriding.overrides(func) and
  call = overriding.getAMethodCall().getNode() and
  correct_args_if_called_as_method(call, overriding) and
  (
    arg_count(call) + 1 < func.minParameters() and problem = "too few arguments"
    or
    arg_count(call) >= func.maxParameters() and problem = "too many arguments"
    or
    exists(string name |
      call.getAKeyword().getArg() = name and
      overriding.getScope().getAnArg().(Name).getId() = name and
      not func.getScope().getAnArg().(Name).getId() = name and
      problem = "an argument named '" + name + "'"
    )
  )
select func,
  "Overridden method signature does not match $@, where it is passed " + problem +
    ". Overriding method $@ matches the call.", call, "call", overriding,
  overriding.descriptiveString()
