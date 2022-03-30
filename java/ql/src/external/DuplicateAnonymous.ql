/**
 * @deprecated
 * @name Duplicate anonymous class
 * @description Duplicated anonymous classes indicate that refactoring is necessary.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/duplicate-anonymous-class
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java

from AnonymousClass c, AnonymousClass other
where none()
select c, "Anonymous class is identical to $@.", other,
  "another anonymous class in " + other.getFile().getStem()
