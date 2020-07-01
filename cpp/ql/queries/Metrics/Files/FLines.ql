/**
 * @name Number of lines
 * @description The number of lines in each file.
 * @kind treemap
 * @id cpp/lines-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLines() as n order by n desc
