/**
 * @name Misnamed class
 * @description A class name that begins with a lowercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id python/misnamed-type
 * @tags maintainability
 */

import python

from Class c
where
  c.inSource() and
  not c.getName().substring(0, 1).toUpperCase() = c.getName().substring(0, 1)
select c, "Class names should start in uppercase."
