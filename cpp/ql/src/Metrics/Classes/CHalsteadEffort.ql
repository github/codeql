/**
 * @name Halstead effort
 * @description Measures the effort to implement the program
 * @kind metric
 * @id cpp/halstead-effort-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 */
import cpp

from MetricClass mc
select mc, mc.getHalsteadEffort()
