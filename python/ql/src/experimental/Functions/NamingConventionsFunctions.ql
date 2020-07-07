/**
 * @name Misnamed function
 * @description A function name that begins with an uppercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @id py/misnamed-function
 * @tags maintainability
 */

import python

from Function f, string first_char
where
  f.inSource() and
  first_char = f.getName().prefix(1) and
  not first_char = first_char.toLowerCase() and
  not exists(Function f1, string first_char1 |
    f1 != f and
    f1.getLocation().getFile() = f.getLocation().getFile() and
    first_char1 = f1.getName().prefix(1) and
    not first_char1 = first_char1.toLowerCase()
  )
select f, "Function names should start in lowercase."
