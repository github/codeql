/**
 * @name Halstead bug measure
 * @description Measures the expected number of delivered defects.
 *              The Halstead bug count is known to be an underestimate.
 * @kind treemap
 * @id cpp/halstead-bugs-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricClass mc
select mc, mc.getHalsteadDeliveredBugs()
