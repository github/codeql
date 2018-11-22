/**
 * @name Halstead vocabulary
 * @description Number of distinct operands and operators used.
 * @kind metric
 * @id cpp/halstead-vocabulary-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 */
import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadVocabulary()
