/**
 * @deprecated
 * @name Mostly duplicate class
 * @description More than 80% of the methods in this class are duplicated in another class. Create a common supertype to improve code sharing.
 * @kind problem
 * @id cpp/duplicate-class
 * @problem.severity recommendation
 * @precision medium
 * @tags testability
 *       maintainability
 *       duplicate-code
 *       non-attributable
 */

import cpp
import CodeDuplication

from Class c, Class other, string message
where
  mostlyDuplicateClass(c, other, message) and
  not c.isConstructedFrom(_) and
  not other.isConstructedFrom(_) and
  not fileLevelDuplication(c.getFile(), _)
select c, message, other, other.getQualifiedName()
