/**
 * @name Use of 'global' at module level
 * @description Use of the 'global' statement at module level
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/redundant-global-declaration
 */

import python

from Global g
where g.getScope() instanceof Module
select g, "Declaring '" + g.getAName() + "' as global at module-level is redundant."
