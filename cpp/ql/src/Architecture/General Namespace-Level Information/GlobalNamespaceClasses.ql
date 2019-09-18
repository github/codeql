/**
 * @name Global namespace classes
 * @description Finds classes that belong to no namespace.
 * @kind table
 * @id cpp/architecture/global-namespace-classes
 * @tags maintainability
 *       modularity
 */

import cpp

from Class c
where
  c.fromSource() and
  c.isTopLevel() and
  c.getParentScope() instanceof GlobalNamespace
select c, "This class is not declared in any namespace"
