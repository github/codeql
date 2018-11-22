/**
 * @name Halstead bug measure
 * @description Measures the expected number of delivered defects.
 *              The Halstead bug count is known to be an underestimate.
 * @kind metric
 * @id cpp/halstead-bugs-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 */
import cpp

from MetricClass mc
select mc, mc.getHalsteadDeliveredBugs()
