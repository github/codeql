/**
 * @name Incoming dependencies per file
 * @description The number of files that depend on a file.
 * @kind treemap
 * @id cpp/afferent-coupling-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       modularity
 */

import cpp

from File f
where f.fromSource()
select f, f.getMetrics().getAfferentCoupling() as n order by n desc
