/**
 * @name Outgoing dependencies per class
 * @description The number of classes on which a class depends.
 * @kind treemap
 * @id cpp/outgoing-type-dependencies
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags testability
 *       modularity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getEfferentCoupling() as n order by n desc
