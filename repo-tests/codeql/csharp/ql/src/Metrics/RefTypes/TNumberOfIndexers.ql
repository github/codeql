/**
 * @name Number of indexers
 * @description Multiple indexers for a single type might be confusing.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/indexers-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n = count(Indexer i | i.getDeclaringType() = t)
select t, n order by n desc
