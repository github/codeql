/**
 * @name Halstead difficulty
 * @description Measures the error proneness of implementing the program.
 * @kind treemap
 * @id cpp/halstead-difficulty-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricFile mc
where mc.fromSource()
select mc, mc.getHalsteadDifficulty()
