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

from Module m, int n
where n = m.getMetrics().getNumberOfLines()
select m, n order by n desc
