/**
 * @name Number of properties
 * @description Types with a large number of properties might have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/properties-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n = count(Property p | p.getDeclaringType() = t)
select t, n order by n desc
