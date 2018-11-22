/**
 * @name Halstead vocabulary
 * @description Number of distinct operands and operators used
 * @kind metric
 * @id cpp/halstead-vocabulary-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 */
import cpp

from MetricClass mc
select mc, mc.getHalsteadVocabulary()
