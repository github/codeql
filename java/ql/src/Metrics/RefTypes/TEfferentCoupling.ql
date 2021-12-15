/**
 * @name Outgoing type dependencies
 * @description The number of types on which a class depends.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/outgoing-type-dependencies
 * @tags testability
 *       modularity
 *       maintainability
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getEfferentCoupling() as n order by n desc
