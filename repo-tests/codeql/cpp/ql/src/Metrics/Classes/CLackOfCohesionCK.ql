/**
 * @name Lack of cohesion per class (LCOM-CK)
 * @description Lack of cohesion for a class as defined by Chidamber
 *              and Kemerer.
 * @kind treemap
 * @id cpp/lack-of-cohesion-ck
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags modularity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getLackOfCohesionCK() as n order by n desc
