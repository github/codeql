/**
 * @name First parameter of a class method is not named 'cls'
 * @description Using an alternative name for the first parameter of a class method makes code more
 *              difficult to read; PEP8 states that the first parameter to class methods should be 'cls'.
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
  firstArgShouldBeNamedClsAndIsnt(f) and
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
