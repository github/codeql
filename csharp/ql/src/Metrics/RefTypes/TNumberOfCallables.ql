/**
 * @name Number of callables
 * @description Types with a large number of methods might have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/functions-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n =
    count(Callable c | c.getDeclaringType() = t and not c instanceof Accessor) +
      count(Accessor a |
        a.getDeclaringType() = t and
        not a.getDeclaration().(Property).isAutoImplemented() and
        not a.getDeclaration().(Event).isFieldLike()
      )
select t, n order by n desc
