/**
 * @name Halstead difficulty
 * @description Measures the error proneness of implementing the program
 * @kind metric
 * @id cpp/halstead-difficulty-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 */
import cpp

from MetricClass mc
select mc, mc.getHalsteadDifficulty()
