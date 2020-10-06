/**
 * @deprecated
 * @name Mostly duplicate class
 * @description More than 80% of the methods in this class are duplicated in another class. Create a common supertype to improve code sharing.
 * @kind problem
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/mostly-duplicate-class
 */

import python
import CodeDuplication

from Class c, Class other, string message
where
  duplicateScopes(c, other, _, message) and
  count(c.getAStmt()) > 3 and
  not duplicateScopes(c.getEnclosingModule(), _, _, _)
select c, message, other, other.getName()
