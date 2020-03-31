/**
 * @name Size of type APIs
 * @description Types with a large public API might be difficult to use and might have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags testability
 *       modularity
 * @id cs/public-functions-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  t.isPublic() and
  n =
    count(Method m | m.getDeclaringType() = t and m.isPublic()) +
      count(Operator o | o.getDeclaringType() = t and o.isPublic()) +
      count(Property p | p.getDeclaringType() = t and p.isPublic()) +
      count(Indexer i | i.getDeclaringType() = t and i.isPublic()) +
      count(Event e | e.getDeclaringType() = t and e.isPublic())
select t, n order by n desc
