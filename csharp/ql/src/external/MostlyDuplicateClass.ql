/**
 * @deprecated
 * @name Duplicate class
 * @description More than 80% of the methods in this class are duplicated in another class. Create a common supertype to improve code sharing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/duplicate-class
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import csharp
import CodeDuplication

from Class c, string message, Class link
where
  mostlyDuplicateClass(c, link, message) and
  not fileLevelDuplication(c.getFile(), _)
select c, message, link, link.getName()
