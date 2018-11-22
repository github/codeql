/**
 * @name Halstead length
 * @description Total number of operands and operators
 * @kind metric
 * @id cpp/halstead-length-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */
import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadLength()
