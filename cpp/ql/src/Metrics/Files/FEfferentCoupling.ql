/**
 * @name Outgoing dependencies per file
 * @description The number of files that a file depends on.
 * @kind treemap
 * @id cpp/efferent-coupling-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags testability
 *       modularity
 *       maintainability
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getEfferentCoupling() as n order by n desc
