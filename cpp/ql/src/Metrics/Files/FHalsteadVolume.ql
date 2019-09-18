/**
 * @name Halstead volume
 * @description The information contents of the program.
 * @kind treemap
 * @id cpp/halstead-volume-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadVolume()
