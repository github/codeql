/**
 * @name Number of events
 * @description Types with a large number of events might have too many responsibilities or the events might be too detailed.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/events-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n = count(Event e | e.getDeclaringType() = t)
select t, n order by n desc
