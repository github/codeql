/**
 * @name Lack of cohesion (CK)
 * @description Types that lack cohesion (as defined by Chidamber and Kemerer) often have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags modularity
 *       maintainability
 * @id cs/lack-of-cohesion-ck
 */

import csharp

from ValueOrRefType t
where t.isSourceDeclaration()
select t, t.getLackOfCohesionCK() as n order by n desc
