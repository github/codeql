/**
 * @name Incoming module dependencies
 * @description The number of modules that depend on a module.
 * @kind treemap
 * @id py/afferent-coupling-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       modularity
 */

import python

from ModuleMetrics m
select m, m.getAfferentCoupling() as n order by n desc
