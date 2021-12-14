/**
 * @deprecated
 * @name Duplicate method
 * @description Duplicated methods make code more difficult to understand and introduce a risk of
 *              changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/duplicate-method
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java

from Method m, Method other
where none()
select m, "Method " + m.getName() + " is duplicated in $@.", other,
  other.getDeclaringType().getQualifiedName()
