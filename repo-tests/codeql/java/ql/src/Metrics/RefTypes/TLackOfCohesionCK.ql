/**
 * @name Lack of type cohesion (CK)
 * @description Lack of cohesion for a class as defined by Chidamber and Kemerer.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/lack-of-cohesion-ck
 * @tags modularity
 *       maintainability
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getLackOfCohesionCK() as n order by n desc
