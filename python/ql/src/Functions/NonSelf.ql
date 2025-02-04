/**
 * @name First parameter of a method is not named 'self'
 * @description By the PEP8 style guide, the first parameter of a normal method should be named `self`.
 * @kind problem
 * @tags maintainability
 *       readability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/not-named-self
 */

import python
import MethodArgNames

from Function f, string message
where
  firstArgShouldBeNamedSelfAndIsnt(f) and
  (
    if exists(f.getArgName(0))
    then
      message =
        "Normal methods should have 'self', rather than '" + f.getArgName(0) +
          "', as their first parameter."
    else
      message =
        "Normal methods should have at least one parameter (the first of which should be 'self')."
  )
select f, message
