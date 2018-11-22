/**
 * @name Halstead length
 * @description Total number of operands and operators
 * @kind metric
 * @id cpp/halstead-length-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 */
import cpp

from MetricClass mc
select mc, mc.getHalsteadLength()
