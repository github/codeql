/**
 * @name Halstead volume
 * @description The information contents of the program
 * @kind treemap
 * @id cpp/halstead-volume-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricClass mc
select mc, mc.getHalsteadVolume()
