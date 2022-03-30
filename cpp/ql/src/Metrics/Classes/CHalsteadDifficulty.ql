/**
 * @name Halstead difficulty
 * @description Measures the error proneness of implementing the program
 * @kind treemap
 * @id cpp/halstead-difficulty-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricClass mc
select mc, mc.getHalsteadDifficulty()
