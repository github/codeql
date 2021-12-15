/**
 * @name Lack of cohesion (HS)
 * @description Types that lack cohesion (as defined by Henderson-Sellers) often have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags modularity
 * @id cs/lack-of-cohesion-hs
 */

import csharp

from ValueOrRefType t
where t.isSourceDeclaration()
select t, t.getLackOfCohesionHS() as n order by n desc
