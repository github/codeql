/**
 * @name Halstead effort
 * @description Measures the effort to implement the program.
 * @kind metric
 * @id cpp/halstead-effort-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */
import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadEffort()
