/**
 * @name Incoming type dependencies
 * @description The number of types that depend on a type.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/incoming-type-dependencies
 * @tags changeability
 *       modularity
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getAfferentCoupling() as n order by n desc
