/**
 * @name Halstead vocabulary
 * @description Number of distinct operands and operators used.
 * @kind treemap
 * @id cpp/halstead-vocabulary-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadVocabulary()
