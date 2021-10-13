/**
 * @name Use of the 'global' statement.
 * @description Use of the 'global' statement may indicate poor modularity.
 * @kind problem
 * @problem.severity recommendation
 * @sub-severity low
 * @deprecated
 * @precision very-high
 * @id py/use-of-global
 */

import python

from Global g
where not g.getScope() instanceof Module
select g, "Updating global variables except at module initialization is discouraged"
