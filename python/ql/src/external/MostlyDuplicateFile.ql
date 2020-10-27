/**
 * @deprecated
 * @name Mostly duplicate module
 * @description There is another file that shares a lot of the code with this file. Merge the two files to improve maintainability.
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
 * @id py/mostly-duplicate-file
 */

import python
import CodeDuplication

from Module m, Module other, int percent, string message
where duplicateScopes(m, other, percent, message)
select m, message, other, other.getName()
