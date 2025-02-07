/**
 * @name First parameter of a class method is not named 'cls'
 * @description By the PEP8 style guide, the first parameter of a class method should be named `cls`.
 * @kind problem
 * @tags maintainability
 *       readability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/not-named-cls
 */

import python
import MethodArgNames

from Function f, string message
where
  firstArgShouldReferToClsAndDoesnt(f) and
  (
    if exists(f.getArgName(0))
    then
      message =
        "Class methods or methods of a type deriving from type should have 'cls', rather than '" +
          f.getArgName(0) + "', as their first parameter."
    else
      message =
        "Class methods or methods of a type deriving from type should have 'cls' as their first parameter."
  )
select f, message
