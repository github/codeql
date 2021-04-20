/**
 * @name Number of lines
 * @kind treemap
 * @description The number of lines in each file.
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision very-high
 * @id rb/lines-per-file
 * @tags maintainability
 */

import ruby

from File f, int n
where n = f.getMetrics().getNumberOfLines()
select f, n order by n desc
