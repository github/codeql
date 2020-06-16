/**
 * @name Lack of Cohesion in Methods (CK)
 * @description Lack of cohesion in the methods of a class, as defined by Chidamber and Kemerer.
 * @kind treemap
 * @id py/lack-of-cohesion-chidamber-kemerer
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 */

import python

from ClassMetrics cls
select cls, cls.getLackOfCohesionCK() as n order by n desc
