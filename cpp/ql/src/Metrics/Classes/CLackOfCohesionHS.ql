/**
 * @name Lack of cohesion per class (LCOM-HS)
 * @description Lack of cohesion for a class as defined by Henderson-Sellers.
 * @kind treemap
 * @id cpp/lack-of-cohesion-hs
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags modularity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getLackOfCohesionHS() as n order by n desc
