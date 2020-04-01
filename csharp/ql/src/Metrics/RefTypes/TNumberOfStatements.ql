/**
 * @name Number of statements
 * @description Types with a large number of statements might be confusing and have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/statements-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n =
    count(Stmt s |
      s.getEnclosingCallable().getDeclaringType() = t and
      s != s.getEnclosingCallable().getAChild()
    ) // we do not count the top-level block
select t, n order by n desc
