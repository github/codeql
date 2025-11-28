/**
 * @name Lack of Cohesion in a Class (HM)
 * @description Lack of cohesion of a class, as defined by Hitz and Montazeri.
 * @kind treemap
 * @id py/lack-of-cohesion-hitz-montazeri
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 */

import python
private import LegacyPointsTo

from ClassMetrics cls
select cls, cls.getLackOfCohesionHM() as n order by n desc
