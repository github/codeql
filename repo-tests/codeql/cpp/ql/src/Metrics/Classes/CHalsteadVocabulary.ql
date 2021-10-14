/**
 * @name Halstead vocabulary
 * @description Number of distinct operands and operators used
 * @kind treemap
 * @id cpp/halstead-vocabulary-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricClass mc
select mc, mc.getHalsteadVocabulary()
