/**
 * @name Empty statement
 * @description An empty statement hinders readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/empty-statement
 * @tags maintainability
 *       useless-code
 */

import java

from EmptyStmt empty, string action
where
  if exists(LoopStmt l | l.getBody() = empty)
  then action = "turned into '{}'"
  else action = "deleted"
select empty, "This empty statement should be " + action + "."
