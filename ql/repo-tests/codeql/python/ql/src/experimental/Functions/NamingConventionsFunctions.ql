/**
 * @name Misnamed function
 * @description A function name that begins with an uppercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @id py/misnamed-function
 * @tags maintainability
 */

import python

predicate upper_case_function(Function func) {
  exists(string first_char |
    first_char = func.getName().prefix(1) and
    not first_char = first_char.toLowerCase()
  )
}

from Function func
where
  func.inSource() and
  upper_case_function(func) and
  not exists(Function func1 |
    func1 != func and
    func1.getLocation().getFile() = func.getLocation().getFile() and
    upper_case_function(func1)
  )
select func, "Function names should start in lowercase."
