/**
 * @name Lack of type cohesion (HS)
 * @description Lack of cohesion for a type as defined by Henderson-Sellers.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/lack-of-cohesion-hs
 * @tags modularity
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getLackOfCohesionHS() as n order by n desc
