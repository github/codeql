/**
 * @name Incoming dependencies per class
 * @description The number of classes that depend on a class.
 * @kind treemap
 * @id cpp/afferent-coupling-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags maintainability
 *       modularity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getAfferentCoupling() as n order by n desc
