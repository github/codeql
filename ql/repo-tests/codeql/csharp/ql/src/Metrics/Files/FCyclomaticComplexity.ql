/**
 * @name Average cyclomatic complexity of files
 * @description Files with a large number of possible execution paths might be difficult to understand.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags testability
 *       complexity
 * @id cs/average-cyclomatic-complexity-per-file
 */

import csharp

from File f, float n
where n = avg(Callable c | c.getFile() = f | c.getCyclomaticComplexity())
select f, n
