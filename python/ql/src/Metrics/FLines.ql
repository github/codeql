/**
 * @name Number of lines
 * @description The number of lines in each file.
 * @kind treemap
 * @id py/lines-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */

import python

from ModuleMetrics m, int n
where n = m.getNumberOfLines()
select m, n order by n desc
