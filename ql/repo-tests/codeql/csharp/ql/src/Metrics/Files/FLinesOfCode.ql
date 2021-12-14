/**
 * @name Lines of code in files
 * @description Files with a large number of lines might be difficult to understand and increase the chance of merge conflicts.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cs/lines-of-code-in-files
 * @tags maintainability
 *       complexity
 */

import csharp

from File f
select f, f.getNumberOfLinesOfCode() as n order by n desc
