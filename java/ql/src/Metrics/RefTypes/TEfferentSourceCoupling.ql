/**
 * @name Outgoing dependencies to source types
 * @description The number of source types on which a type depends.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/outgoing-source-type-dependencies
 * @tags changeability
 *       maintainability
 *       modularity
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getEfferentSourceCoupling() as n order by n desc
