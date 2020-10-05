/**
 * @deprecated
 * @name Mostly similar module
 * @description There is another module that shares a lot of the code with this module. Notice that names of variables and types may have been changed. Merge the two modules to improve maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 * @sub-severity low
 * @precision high
 * @id py/mostly-similar-file
 */

import python
import CodeDuplication

from Module m, Module other, string message
where similarScopes(m, other, _, message)
select m, message, other, other.getName()
