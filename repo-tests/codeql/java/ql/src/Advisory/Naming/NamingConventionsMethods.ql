/**
 * @name Misnamed method
 * @description A method name that begins with an uppercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/misnamed-function
 * @tags maintainability
 */

import java

from Method m
where
  m.fromSource() and
  not m.getName().substring(0, 1).toLowerCase() = m.getName().substring(0, 1)
select m, "Method names should start in lowercase."
