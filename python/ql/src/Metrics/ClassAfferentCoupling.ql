/**
 * @name Incoming class dependencies
 * @description The number of classes that depend on a class.
 * @kind treemap
 * @id py/afferent-coupling-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags changeability
 *       modularity
 */

import python

from ClassMetrics cls
select cls, cls.getAfferentCoupling() as n order by n desc
