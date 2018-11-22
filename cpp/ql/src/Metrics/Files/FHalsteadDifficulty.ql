/**
 * @name Halstead difficulty
 * @description Measures the error proneness of implementing the program.
 * @kind metric
 * @id cpp/halstead-difficulty-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */
import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadDifficulty()
