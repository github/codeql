/**
 * @name Lines of code in files
 * @kind treemap
 * @description Measures the number of lines in a file that contain
 *              code (rather than lines that only contain comments
 *              or are blank)
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cpp/lines-of-code-in-files
 * @tags maintainability
 *       complexity
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLinesOfCode() as n order by n desc
