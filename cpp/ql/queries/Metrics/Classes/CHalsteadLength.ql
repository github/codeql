/**
 * @name Halstead length
 * @description Total number of operands and operators
 * @kind treemap
 * @id cpp/halstead-length-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from MetricClass mc
select mc, mc.getHalsteadLength()
