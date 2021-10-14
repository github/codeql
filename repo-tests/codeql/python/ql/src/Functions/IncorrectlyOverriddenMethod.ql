/**
 * @name Mismatch between signature and use of an overriding method
 * @description Method has a different signature from the overridden method and, if it were called, would be likely to cause an error.
 * @kind problem
 * @tags maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/inheritance/incorrect-overriding-signature
 */

import python
import Expressions.CallArgs

from Call call, FunctionValue func, FunctionValue overridden, string problem
where
  func.overrides(overridden) and
  (
    wrong_args(call, func, _, problem) and
    correct_args_if_called_as_method(call, overridden)
    or
    exists(string name |
      illegally_named_parameter(call, func, name) and
      problem = "an argument named '" + name + "'" and
      overridden.getScope().getAnArg().(Name).getId() = name
    )
  )
select func,
  "Overriding method signature does not match $@, where it is passed " + problem +
    ". Overridden method $@ is correctly specified.", call, "here", overridden,
  overridden.descriptiveString()
