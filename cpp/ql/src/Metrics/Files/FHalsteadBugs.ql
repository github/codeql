/**
 * @name Halstead bug measure
 * @description Measures the expected number of delivered bugs. The
 *              Halstead bug count is known to be an underestimate.
 * @kind metric
 * @id cpp/halstead-bugs-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */
import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadDeliveredBugs()
