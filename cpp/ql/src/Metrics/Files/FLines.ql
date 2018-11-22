/**
 * @name Number of lines
 * @description The number of lines in each file.
 * @kind metric
 * @id cpp/lines-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */
import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getNumberOfLines() as n
order by n desc
