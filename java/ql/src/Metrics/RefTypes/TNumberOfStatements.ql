/**
 * @name Number of statements in types
 * @description The number of statements in the methods and constructors of a type.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id java/statements-per-type
 * @tags maintainability
 */

import java

from RefType t, int n
where
  t.fromSource() and
  n = count(Stmt s | s.getEnclosingCallable() = t.getACallable())
select t, n order by n desc
