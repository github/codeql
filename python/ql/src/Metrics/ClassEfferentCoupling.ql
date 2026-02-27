/**
 * @name Outgoing class dependencies
 * @description The number of classes that this class depends upon.
 * @kind treemap
 * @id py/efferent-coupling-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags testability
 *       modularity
 */

import python

from ClassMetrics cls
select cls, cls.getEfferentCoupling() as n order by n desc
