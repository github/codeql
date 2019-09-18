/**
 * @name Empty interface
 * @description Empty interfaces (those that do not declare any members) are often used as "markers" to
 *              associate metadata with a class, but custom attributes are a better alternative.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/empty-interface
 * @tags maintainability
 *       modularity
 */

import csharp

from Interface i
where
  not exists(i.getAMember()) and
  i.isSourceDeclaration() and
  count(Interface base | i.getABaseInterface() = base) <= 1
select i, "Interface '" + i.getName() + "' does not declare any members."
