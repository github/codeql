/**
 * @name Misnamed class
 * @description A class name that begins with a lowercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @id py/misnamed-class
 * @tags maintainability
 */

import python

predicate lower_case_class(Class c) {
  exists(string first_char |
    first_char = c.getName().prefix(1) and
    not first_char = first_char.toUpperCase()
  )
}

from Class c
where
  c.inSource() and
  lower_case_class(c) and
  not exists(Class c1 |
    c1 != c and
    c1.getLocation().getFile() = c.getLocation().getFile() and
    lower_case_class(c1)
  )
select c, "Class names should start in uppercase."
