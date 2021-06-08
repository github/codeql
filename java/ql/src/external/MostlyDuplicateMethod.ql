/**
 * @deprecated
 * @name Mostly duplicate method
 * @description Methods in which most of the lines are duplicated in another method make code more
 *              difficult to understand and introduce a risk of changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/similar-method
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java

from Method m, Method other, int percent
where none()
select m, percent + "% of the statements in " + m.getName() + " are duplicated in $@.", other,
  other.getDeclaringType().getName() + "." + other.getStringSignature()
