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

from Module m, Module other, string message
where none()
select m, message, other, other.getName()
