/**
 * @name Outgoing module dependencies
 * @description The number of modules that this module depends upon.
 * @kind treemap
 * @id py/efferent-coupling-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags testability
 *       modularity
 */

import python

from ModuleMetrics m
select m, m.getEfferentCoupling() as n order by n desc
