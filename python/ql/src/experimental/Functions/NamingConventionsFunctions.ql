/**
 * @name Misnamed function
 * @description A function name that begins with an uppercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id python/misnamed-function
 * @tags maintainability
 */

import python

from Function f
where
  f.inSource() and
  not f.getName().substring(0, 1).toLowerCase() = f.getName().substring(0, 1)
select f, "Function names should start in lowercase."
