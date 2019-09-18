/**
 * @name Number of statements in methods
 * @description The number of statements in a method or constructor.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @id java/statements-per-function
 * @tags maintainability
 */

import java

from Callable c, int n
where
  c.fromSource() and
  n = count(Stmt s | s.getEnclosingCallable() = c)
select c, n order by n desc
