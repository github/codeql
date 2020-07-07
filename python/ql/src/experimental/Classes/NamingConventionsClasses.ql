/**
 * @name Misnamed class
 * @description A class name that begins with a lowercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @id py/misnamed-class
 * @tags maintainability
 */

import python

from Class c, string first_char
where
  c.inSource() and
  first_char = c.getName().prefix(1) and
  not first_char = first_char.toUpperCase() and
  not exists(Class c1, string first_char1 |
    c1 != c and
    c1.getLocation().getFile() = c.getLocation().getFile() and
    first_char1 = c1.getName().prefix(1) and
    not first_char1 = first_char1.toUpperCase()
  )
select c, "Class names should start in uppercase."
