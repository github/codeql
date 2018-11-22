/**
 * @name Halstead volume
 * @description The information contents of the program
 * @kind metric
 * @id cpp/halstead-volume-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 */
import cpp

from MetricClass mc
select mc, mc.getHalsteadVolume()
